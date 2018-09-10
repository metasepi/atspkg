{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE DeriveAnyClass             #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE StandaloneDeriving         #-}

module Language.ATS.Package.Debian ( debRules
                                   , Debian (..)
                                   ) where

import           Data.Dependency            (Version (..))
import           Data.List                  (intercalate)
import           Development.Shake          hiding ((*>))
import           Development.Shake.FilePath
import           Dhall                      hiding (Text)
import           Quaalude

data Debian = Debian { package     :: Text
                     , version     :: Version
                     , maintainer  :: Text
                     , description :: Text
                     , target      :: Text
                     , manpage     :: Maybe Text
                     , binaries    :: [Text]
                     , libraries   :: [Text]
                     , headers     :: [Text]
                     }
                     deriving (Generic, Binary, Interpret)

deriving newtype instance Interpret Version

control :: Debian -> String
control Debian{..} = intercalate "\n"
    [ "Package: " ++ unpack package
    , "Version: " ++ show version
    , "Architecture: all"
    , "Maintainer: " ++ unpack maintainer
    , "Description: " ++ unpack description
    , mempty
    ]

-- look at hackage package for debian?
debRules :: Debian -> Rules ()
debRules deb =
    unpack (target deb) %> \out -> do

        traverse_ need [ unpack <$> binaries deb
                       , unpack <$> libraries deb
                       , unpack <$> headers deb
                       ]

        let packDir = unpack (package deb)
            makeRel = (("target" </> packDir) </>)
            debianDir = makeRel "/DEBIAN"
            binDir = makeRel "/usr/local/bin"
            libDir = makeRel "/usr/local/lib"
            manDir = makeRel "/usr/local/share/man/man1"
            includeDir = makeRel "/usr/local/include"

        traverse_ (liftIO . createDirectoryIfMissing True)
            [ binDir, debianDir, manDir, includeDir ]

        fold $ do
            mp <- manpage deb
            pure $
                need [unpack mp] *>
                copyFile' (unpack mp) (manDir ++ "/" ++ takeFileName (unpack mp))

        zipWithM_ copyFile' (unpack <$> binaries deb) ((binDir </>) . unpack <$> binaries deb)
        zipWithM_ copyFile' (unpack <$> libraries deb) ((libDir </>) . unpack <$> libraries deb)
        zipWithM_ copyFile' (unpack <$> headers deb) ((includeDir </>) . unpack <$> headers deb)

        writeFileChanged (debianDir ++ "/control") (control deb)

        command [Cwd "target"] "dpkg-deb" ["--build", packDir, dropDirectory1 out]
