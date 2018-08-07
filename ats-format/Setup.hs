import           Distribution.CommandLine
import           Distribution.Simple
import           System.FilePath

main :: IO ()
main = mconcat [ setManpath
               , writeManpages ("man" </> "atsfmt.1") "atsfmt.1"
               , writeBashCompletions "atsfmt"
               , defaultMain
               ]
