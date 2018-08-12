absprop FUNCTOR_PROP (A : prop, n : int)

absprop BASE_FUNCTOR_PROP (A : prop, B : prop)

// TODO: proof-level paramorphisms?
dataprop LIST_PROP(A: prop, int) =
  | LIST_PROP_NIL(A, 0) of ()
  | { n : nat | n > 0 } LIST_PROP_CONS(A, n) of (A, LIST_PROP(A, n - 1))

dataprop LISTF_PROP(A: prop, B: prop) =
  | LISTF_PROP_NIL(A, B) of ()
  | LISTF_PROP_CONS(A, B) of (A, B)

extern
prfun MAP {A:prop}{B:prop}{n:nat} ( F : A -<prf> B
                                  , X : FUNCTOR_PROP(A, n)
                                  ) : FUNCTOR_PROP(B, n)

extern
prfun MAP_ {A:prop}{B:prop}{C:prop}{n:nat} ( F : B -<prf> C
                                           , X : BASE_FUNCTOR_PROP(A, B)
                                           ) : BASE_FUNCTOR_PROP(A, C)

assume FUNCTOR_PROP(A, n) = LIST_PROP(A, n)
assume BASE_FUNCTOR_PROP(A, B) = LISTF_PROP(A, B)

propdef ALGEBRA (A : prop, B : prop) = BASE_FUNCTOR_PROP(A, B) -<prf> B

primplmnt MAP_ (F, XS) =
  case+ XS of
    | LISTF_PROP_NIL() => LISTF_PROP_NIL()
    | LISTF_PROP_CONS (Y, YS) => LISTF_PROP_CONS(Y,F(YS))

extern
prfun {A:prop}{B:prop} CATA {n:nat} (ALGEBRA(A,B), FUNCTOR_PROP(A,n)) :
  B

extern
prfun {A:prop} PROJECT {n:nat} (FUNCTOR_PROP(A,n)) :
  BASE_FUNCTOR_PROP(A, FUNCTOR_PROP(A,n-1))

primplmnt {A}{B} CATA (F, A) =
  F(MAP_(lam A0 =<prf> CATA(F,A0),PROJECT(A)))

