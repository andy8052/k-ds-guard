requires "edsl.k"

module RULES
    imports EVM
    imports EDSL
    imports K-REFLECTION

// VERIFICATION.k

    rule #rangeUInt    (   1 ,      X ) => #range ( 0               <= X <= 1               ) [macro]

    syntax Int ::= nthbyteof ( Int , Int , Int ) [function, smtlib(smt_nthbyteof), proj]
 // ------------------------------------------------------------------------------
    rule nthbyteof(V, I, N) => nthbyteof(V /Int 256, I, N -Int 1) when N  >Int (I +Int 1) [concrete]
    rule nthbyteof(V, I, N) =>           V modInt 256             when N ==Int (I +Int 1) [concrete]

    rule bool2Word(notBool(A ==K 0)) => A
         requires #rangeUInt(1, A)

    //Blasphemy
    rule notBool(notBool(A)) => A

    rule ( WS1 ++ WS2 ) ++ WS3 => WS1 ++ ( WS2 ++ WS3 )

    syntax WordStack ::= #bufSeg ( WordStack , Int , Int ) [function, smtlib(bufSeg)] // BUFFER, START, WIDTH
    syntax Int       ::= #bufElm ( WordStack , Int )       [function] // BUFFER, INDEX

    syntax Bool ::= #isBuf ( WordStack ) [function]
    rule #isBuf(#buf(_,_)) => true
    rule #isBuf(#bufSeg(_,_,_)) => true

    rule #asWord(#buf(SIZE, DATA)) => DATA requires SIZE <=Int 32

    rule #buf(SIZE, _)        => .WordStack requires SIZE  ==Int 0
    rule #bufSeg(_, _, WIDTH) => .WordStack requires WIDTH ==Int 0

    rule #bufSeg(WS, START, WIDTH) => WS requires START ==Int 0 andBool WIDTH ==Int #sizeWordStack(WS)

    rule #bufSeg(#bufSeg(BUF, START0, WIDTH0), START, WIDTH)
      => #bufSeg(BUF, START0 +Int START, WIDTH)
      requires 0 <=Int START andBool START +Int WIDTH <=Int WIDTH0

    // Auxiliary function to make rules compatible with simplification `rule WS ++ .WordStack => WS`
    syntax WordStack ::= #takeAux ( Int , WordStack , WordStack ) [function]
 // ------------------------------------------------------------------------
    rule #take(N, BUF      ) => #takeAux(N, BUF, .WordStack)               requires #isBuf(BUF)
    rule #take(N, BUF ++ WS) => #takeAux(N, BUF, WS)                       requires #isBuf(BUF)
    rule #takeAux(N, BUF, WS) => #bufSeg(BUF, 0, N)                        requires 0 <=Int N andBool N <=Int #sizeBuffer(BUF)
    rule #takeAux(N, BUF, WS) => BUF ++ #take(N -Int #sizeBuffer(BUF), WS) requires N >Int #sizeBuffer(BUF)

    syntax WordStack ::= #dropAux ( Int , WordStack , WordStack ) [function]
 // ------------------------------------------------------------------------
    rule #drop(N, BUF      ) => #dropAux(N, BUF, .WordStack)                    requires #isBuf(BUF)
    rule #drop(N, BUF ++ WS) => #dropAux(N, BUF, WS)                            requires #isBuf(BUF)
    rule #dropAux(N, BUF, WS) => #bufSeg(BUF, N, #sizeBuffer(BUF) -Int N) ++ WS requires 0 <=Int N andBool N <=Int #sizeBuffer(BUF)
    rule #dropAux(N, BUF, WS) => #drop(N -Int #sizeBuffer(BUF), WS)             requires N >=Int #sizeBuffer(BUF)

    syntax Int ::= #getElmAux ( WordStack , WordStack , Int ) [function]
 // --------------------------------------------------------------------
    rule (BUF      ) [ N ] => #getElmAux(BUF, .WordStack, N)      requires #isBuf(BUF)
    rule (BUF ++ WS) [ N ] => #getElmAux(BUF, WS, N)              requires #isBuf(BUF)
    rule #getElmAux(BUF, WS, N) => #bufElm(BUF, N)                requires 0 <=Int N andBool N <Int #sizeBuffer(BUF)
    rule #getElmAux(BUF, WS, N) => WS [ N -Int #sizeBuffer(BUF) ] requires N >=Int #sizeBuffer(BUF)


    rule #sizeWordStack ( BUF ++ WS, SIZE ) => #sizeWordStack(WS, SIZE +Int #sizeBuffer(BUF)) requires #isBuf(BUF)
    rule #sizeWordStack ( BUF      , SIZE ) =>                    SIZE +Int #sizeBuffer(BUF)  requires #isBuf(BUF)

    syntax Int ::= #sizeBuffer ( WordStack ) [function]
 // ---------------------------------------------------
    rule #sizeBuffer ( #buf(N,_) )      => N
    rule #sizeBuffer ( #bufSeg(_,_,N) ) => N

    // Same rules exist in KEVM, but are marked [concrete]. Allowing them for symbolic arguments here.

    rule #lookup( (KEY |-> VAL) M, KEY ) => VAL
    rule #lookup(               M, KEY ) => 0 requires notBool KEY in_keys(M)

    rule #range(WM, START, WIDTH) => #range(WM, START +Int WIDTH -Int 1, WIDTH, .WordStack)

    rule WM[ N := W : WS     ] => (WM[N <- W])[N +Int 1 := WS]

    //semantics of #buf
    rule #buf(LEN, BYTES) => #padToWidth(LEN, #asByteStack( BYTES ))



    rule 0 <=Int nthbyteof(V, I, N)          => true
    rule         nthbyteof(V, I, N) <Int 256 => true

    rule #asWord( nthbyteof(V,  0, 32)
                : nthbyteof(V,  1, 32)
                : nthbyteof(V,  2, 32)
                : nthbyteof(V,  3, 32)
                : nthbyteof(V,  4, 32)
                : nthbyteof(V,  5, 32)
                : nthbyteof(V,  6, 32)
                : nthbyteof(V,  7, 32)
                : nthbyteof(V,  8, 32)
                : nthbyteof(V,  9, 32)
                : nthbyteof(V, 10, 32)
                : nthbyteof(V, 11, 32)
                : nthbyteof(V, 12, 32)
                : nthbyteof(V, 13, 32)
                : nthbyteof(V, 14, 32)
                : nthbyteof(V, 15, 32)
                : nthbyteof(V, 16, 32)
                : nthbyteof(V, 17, 32)
                : nthbyteof(V, 18, 32)
                : nthbyteof(V, 19, 32)
                : nthbyteof(V, 20, 32)
                : nthbyteof(V, 21, 32)
                : nthbyteof(V, 22, 32)
                : nthbyteof(V, 23, 32)
                : nthbyteof(V, 24, 32)
                : nthbyteof(V, 25, 32)
                : nthbyteof(V, 26, 32)
                : nthbyteof(V, 27, 32)
                : nthbyteof(V, 28, 32)
                : nthbyteof(V, 29, 32)
                : nthbyteof(V, 30, 32)
                : nthbyteof(V, 31, 32)
                : .WordStack ) => V
      requires 0 <=Int V andBool V <Int pow256


    rule #asWord( nthbyteof(#unsigned(V),  0, 32)
                : nthbyteof(#unsigned(V),  1, 32)
                : nthbyteof(#unsigned(V),  2, 32)
                : nthbyteof(#unsigned(V),  3, 32)
                : nthbyteof(#unsigned(V),  4, 32)
                : nthbyteof(#unsigned(V),  5, 32)
                : nthbyteof(#unsigned(V),  6, 32)
                : nthbyteof(#unsigned(V),  7, 32)
                : nthbyteof(#unsigned(V),  8, 32)
                : nthbyteof(#unsigned(V),  9, 32)
                : nthbyteof(#unsigned(V), 10, 32)
                : nthbyteof(#unsigned(V), 11, 32)
                : nthbyteof(#unsigned(V), 12, 32)
                : nthbyteof(#unsigned(V), 13, 32)
                : nthbyteof(#unsigned(V), 14, 32)
                : nthbyteof(#unsigned(V), 15, 32)
                : nthbyteof(#unsigned(V), 16, 32)
                : nthbyteof(#unsigned(V), 17, 32)
                : nthbyteof(#unsigned(V), 18, 32)
                : nthbyteof(#unsigned(V), 19, 32)
                : nthbyteof(#unsigned(V), 20, 32)
                : nthbyteof(#unsigned(V), 21, 32)
                : nthbyteof(#unsigned(V), 22, 32)
                : nthbyteof(#unsigned(V), 23, 32)
                : nthbyteof(#unsigned(V), 24, 32)
                : nthbyteof(#unsigned(V), 25, 32)
                : nthbyteof(#unsigned(V), 26, 32)
                : nthbyteof(#unsigned(V), 27, 32)
                : nthbyteof(#unsigned(V), 28, 32)
                : nthbyteof(#unsigned(V), 29, 32)
                : nthbyteof(#unsigned(V), 30, 32)
                : nthbyteof(#unsigned(V), 31, 32)
                : .WordStack ) => #unsigned(V)
      requires #rangeSInt(256, V)

    rule #asWord( nthbyteof(keccakIntList(V),  0, 32)
                : nthbyteof(keccakIntList(V),  1, 32)
                : nthbyteof(keccakIntList(V),  2, 32)
                : nthbyteof(keccakIntList(V),  3, 32)
                : nthbyteof(keccakIntList(V),  4, 32)
                : nthbyteof(keccakIntList(V),  5, 32)
                : nthbyteof(keccakIntList(V),  6, 32)
                : nthbyteof(keccakIntList(V),  7, 32)
                : nthbyteof(keccakIntList(V),  8, 32)
                : nthbyteof(keccakIntList(V),  9, 32)
                : nthbyteof(keccakIntList(V), 10, 32)
                : nthbyteof(keccakIntList(V), 11, 32)
                : nthbyteof(keccakIntList(V), 12, 32)
                : nthbyteof(keccakIntList(V), 13, 32)
                : nthbyteof(keccakIntList(V), 14, 32)
                : nthbyteof(keccakIntList(V), 15, 32)
                : nthbyteof(keccakIntList(V), 16, 32)
                : nthbyteof(keccakIntList(V), 17, 32)
                : nthbyteof(keccakIntList(V), 18, 32)
                : nthbyteof(keccakIntList(V), 19, 32)
                : nthbyteof(keccakIntList(V), 20, 32)
                : nthbyteof(keccakIntList(V), 21, 32)
                : nthbyteof(keccakIntList(V), 22, 32)
                : nthbyteof(keccakIntList(V), 23, 32)
                : nthbyteof(keccakIntList(V), 24, 32)
                : nthbyteof(keccakIntList(V), 25, 32)
                : nthbyteof(keccakIntList(V), 26, 32)
                : nthbyteof(keccakIntList(V), 27, 32)
                : nthbyteof(keccakIntList(V), 28, 32)
                : nthbyteof(keccakIntList(V), 29, 32)
                : nthbyteof(keccakIntList(V), 30, 32)
                : nthbyteof(keccakIntList(V), 31, 32)
                : .WordStack ) => keccakIntList(V)

    rule #asWord( nthbyteof(#symEcrec(V),  0, 32)
                : nthbyteof(#symEcrec(V),  1, 32)
                : nthbyteof(#symEcrec(V),  2, 32)
                : nthbyteof(#symEcrec(V),  3, 32)
                : nthbyteof(#symEcrec(V),  4, 32)
                : nthbyteof(#symEcrec(V),  5, 32)
                : nthbyteof(#symEcrec(V),  6, 32)
                : nthbyteof(#symEcrec(V),  7, 32)
                : nthbyteof(#symEcrec(V),  8, 32)
                : nthbyteof(#symEcrec(V),  9, 32)
                : nthbyteof(#symEcrec(V), 10, 32)
                : nthbyteof(#symEcrec(V), 11, 32)
                : nthbyteof(#symEcrec(V), 12, 32)
                : nthbyteof(#symEcrec(V), 13, 32)
                : nthbyteof(#symEcrec(V), 14, 32)
                : nthbyteof(#symEcrec(V), 15, 32)
                : nthbyteof(#symEcrec(V), 16, 32)
                : nthbyteof(#symEcrec(V), 17, 32)
                : nthbyteof(#symEcrec(V), 18, 32)
                : nthbyteof(#symEcrec(V), 19, 32)
                : nthbyteof(#symEcrec(V), 20, 32)
                : nthbyteof(#symEcrec(V), 21, 32)
                : nthbyteof(#symEcrec(V), 22, 32)
                : nthbyteof(#symEcrec(V), 23, 32)
                : nthbyteof(#symEcrec(V), 24, 32)
                : nthbyteof(#symEcrec(V), 25, 32)
                : nthbyteof(#symEcrec(V), 26, 32)
                : nthbyteof(#symEcrec(V), 27, 32)
                : nthbyteof(#symEcrec(V), 28, 32)
                : nthbyteof(#symEcrec(V), 29, 32)
                : nthbyteof(#symEcrec(V), 30, 32)
                : nthbyteof(#symEcrec(V), 31, 32)
                : .WordStack ) => #symEcrec(V)


rule ACCTCODE in SetItem( 1 )
                 SetItem ( 2 )
                 SetItem ( 3 )
                 SetItem ( 4 )
                 SetItem ( 5 )
                 SetItem ( 6 )
                 SetItem ( 7 )
                 SetItem ( 8 )
                 => false
     requires 9 <=Int ACCTCODE


// for terms came from bytecode not via #hashedLocation
    rule keccak(WS) => keccakIntList(byteStack2IntList(WS))
      requires ( notBool #isConcrete(WS) )
       andBool ( #sizeWordStack(WS) modInt 32 ==Int 0)

    rule 0 <=Int keccakIntList(N)     => true
    rule keccaktIntList(N) <Int pow256 => true


    rule #padToWidth(32, #asByteStack( #unsigned(V) )) => #asByteStackInWidth( #unsigned(V), 32)
      requires #rangeSInt(256, V)


    rule #padToWidth(32, #asByteStack(V)) => #asByteStackInWidth(V, 32)
      requires 0 <=Int V andBool V <Int pow256


    rule #padToWidth(32, #asByteStack( keccakIntList (V) )) => #asByteStackInWidth( keccakIntList (V), 32)

    rule #padToWidth(32, #asByteStack( #symEcrec(V) )) => #asByteStackInWidth( #symEcrec(V), 32)


   // for Vyper
    rule #padToWidth(N, #asByteStack(#asWord(WS))) => WS
      requires #sizeWordStack(WS) <=Int 32 andBool N ==Int #sizeWordStack(WS)

    // storing a symbolic boolean value in memory
    rule #padToWidth(32, #asByteStack(bool2Word(E)))
      => #asByteStackInWidthaux(0, 30, 32, nthbyteof(bool2Word(E), 31, 32) : .WordStack)

    // for Solidity
    rule #asWord(WS) /Int D => #asWord(#take(#sizeWordStack(WS) -Int log256Int(D), WS))
      requires D modInt 256 ==Int 0 andBool D >=Int 0
       andBool #sizeWordStack(WS) >=Int log256Int(D)
       andBool #sizeWordStack(WS) <=Int 32

    // for Solidity >= 0.5.6
    rule #asWord(WS) >>Int D => #asWord(#take(#sizeWordStack(WS) -Int (D /Int 8), WS))
     requires D modInt 8 ==Int 0 andBool D >=Int 0
       andBool #sizeWordStack(WS) >=Int (D /Int 8)
       andBool #sizeWordStack(WS) <=Int 32
    rule #sizeWordStack(#take(N, _)) => N
    rule #sizeWordStack(#take(N, _), M) => N +Int M

    syntax WordStack ::= #asByteStackInWidth    ( Int, Int )                 [function]
                       | #asByteStackInWidthaux ( Int, Int, Int, WordStack ) [function]
 // -----------------------------------------------------------------------------------
    rule #asByteStackInWidth(X, N) => #asByteStackInWidthaux(X, N -Int 1, N, .WordStack)

    rule #asByteStackInWidthaux(X, I, N, WS) => #asByteStackInWidthaux(X, I -Int 1, N, nthbyteof(X, I, N) : WS) when I >Int 0
    rule #asByteStackInWidthaux(X, 0, N, WS) => nthbyteof(X, 0, N) : WS

    rule 0 +Int N => N
    rule N +Int 0 => N

    rule N -Int 0 => N

    rule 1 *Int N => N
    rule N *Int 1 => N
    rule 0 *Int _ => 0
    rule _ *Int 0 => 0

    rule N /Int 1 => N
    rule N *Int A /Int A => N

    rule 0 |Int N => N
    rule N |Int 0 => N
    rule N |Int N => N

    rule 0 &Int N => 0
    rule N &Int 0 => 0
    rule N &Int N => N

    rule N <<Int 0 => N
    rule N >>Int 0 => N

    rule (I1 +Int I2) +Int I3 => I1 +Int (I2 +Int I3) when #isConcrete(I2) andBool #isConcrete(I3)
    rule (I1 +Int I2) -Int I3 => I1 +Int (I2 -Int I3) when #isConcrete(I2) andBool #isConcrete(I3)
    rule (I1 -Int I2) +Int I3 => I1 -Int (I2 -Int I3) when #isConcrete(I2) andBool #isConcrete(I3)
    rule (I1 -Int I2) -Int I3 => I1 -Int (I2 +Int I3) when #isConcrete(I2) andBool #isConcrete(I3)

    rule I1 &Int (I2 &Int I3) => (I1 &Int I2) &Int I3 when #isConcrete(I1) andBool #isConcrete(I2)

    // 0xffff...f &Int N = N
    rule MASK &Int N => N  requires MASK ==Int (2 ^Int (log2Int(MASK) +Int 1)) -Int 1 // MASK = 0xffff...f
                            andBool 0 <=Int N andBool N <=Int MASK

    // 0xffff...f &Int N = N
    rule N &Int MASK => N  requires MASK ==Int (2 ^Int (log2Int(MASK) +Int 1)) -Int 1 // MASK = 0xffff...f
                            andBool 0 <=Int N andBool N <=Int MASK


    // for gas calculation
    rule A -Int (#if C #then B1 #else B2 #fi) => #if C #then (A -Int B1) #else (A -Int B2) #fi
         requires #isConcrete(A)

    rule (#if C #then B1 #else B2 #fi) -Int A => #if C #then (B1 -Int A) #else (B2 -Int A) #fi
         requires #isConcrete(A)
    rule (#if C #then B1 #else B2 #fi) +Int A => #if C #then (B1 +Int A) #else (B2 +Int A) #fi
         requires #isConcrete(A)
    rule (#if C #then B1 #else B2 #fi) >Int A => true
       requires B1 >Int A andBool B2 >Int A

    rule (A -Int A /Int 64) -Int B -Int (#if C #then B1 #else B2 #fi) =>
    #if C #then (A -Int A /Int 64) -Int B1 #else (A -Int A /Int 64) -Int B2 #fi -Int B

    rule (#if C #then B1 #else B2 #fi) >=Int A => true
       requires B1 >=Int A andBool B2 >=Int A

    rule #if C #then (#if C #then B1 #else B2 #fi) -Int D #else (#if C #then B3 #else B4 #fi) -Int E #fi =>
         #if C #then B1 -Int D #else B4 -Int E #fi


    rule A -Int A => 0

    rule bool2Word(A) |Int bool2Word(B) => bool2Word(A  orBool B)
    rule bool2Word(A) &Int bool2Word(B) => bool2Word(A andBool B)

    rule bool2Word(A)  ==K 0 => notBool(A)
    rule bool2Word(A)  ==K 1 => A

    rule chop(bool2Word(B)) => bool2Word(B)





    rule 0 <=Int chop(V)             => true
    rule         chop(V) <Int pow256 => true

    rule 0 <=Int keccak(V)             => true
    rule         keccak(V) <Int pow256 => true

    rule 0 <=Int X &Int Y             => true requires 0 <=Int X andBool X <Int pow256 andBool 0 <=Int Y andBool Y <Int pow256
    rule         X &Int Y <Int pow256 => true requires 0 <=Int X andBool X <Int pow256 andBool 0 <=Int Y andBool Y <Int pow256





    rule chop(I) => I requires 0 <=Int I andBool I <Int pow256




    rule #sizeWordStack ( _ , _ ) >=Int 0 => true [smt-lemma]
    rule #sizeWordStack ( WS , N:Int )
      => #sizeWordStack ( WS , 0 ) +Int N
      requires N =/=K 0
      [lemma]

rule chop(#unsigned(W)) => #unsigned(W)
  requires #rangeSInt(256, W)

rule #signed(#unsigned(W)) => W
  requires #rangeSInt(256, W)

rule #unsigned(#signed(W)) => W
  requires #rangeUInt(256, W)

rule W0 s<Word W1 => #signed(W0) <Word #signed(W1)

rule   #signed(X) ==K   #signed(Y) => X ==K Y requires #rangeUInt(256,X) orBool #rangeUInt(256,Y)
rule #unsigned(X) ==K #unsigned(Y) => X ==K Y requires #rangeSInt(256,X) orBool #rangeSInt(256,Y)


rule A modInt pow160 => A
  requires #rangeAddress(A)

syntax Bool ::= #notPrecompileAddress ( Int ) [function]
// ---------------------------------------
rule #notPrecompileAddress ( X ) => 0 <Int X andBool 9 <=Int X andBool #rangeAddress(X)

// ABSTRACT SEMANTICS.k

  rule <k> LT W0 W1 => bool2Word(W0  <Int W1) ~> #push ... </k> [trusted]
  rule <k> GT W0 W1 => bool2Word(W0  >Int W1) ~> #push ... </k> [trusted]
  rule <k> EQ W0 W1 => bool2Word(W0 ==Int W1) ~> #push ... </k> [trusted]
  rule <k> ISZERO W => bool2Word(W  ==Int 0 ) ~> #push ... </k> [trusted]


//RULES MUST USE ==K and not ==Int
//Warning: assumes injective hashing
rule keccakIntList(A B .IntList) ==K keccakIntList(C D .IntList) => A ==Int C andBool B ==Int D

rule keccakIntList(A B C .IntList) ==K keccakIntList(D E F .IntList) => A ==Int D andBool B ==Int E andBool C ==Int F


rule keccakIntList(C) ==K A => false
     requires 0 <=Int A andBool A <=Int 20

rule keccakIntList(C) +Int B ==K A => false
     requires 0 <=Int A andBool A <=Int 20
     andBool 0 <=Int B andBool B <=Int 20

rule A ==K keccakIntList(C) +Int B => false
     requires 0 <=Int A andBool A <=Int 20
     andBool 0 <=Int B andBool B <=Int 20

rule keccakIntList(C) +Int B ==K keccakIntList(A) => false
     requires 0 <=Int B andBool B <=Int 20

rule keccakIntList(A) +Int B ==K keccakIntList(A) +Int C => false
     requires B =/=Int C

rule keccakIntList(A) +Int B ==K keccakIntList(C) +Int D => false
     requires B =/=K C


rule keccakIntList(A) ==K keccakIntList(C) +Int B => false
     requires 0 <=Int B andBool B <=Int 20


rule A ==K keccakIntList(C) => false
     requires 0 <=Int A andBool A <=Int 20

rule Cgascap(SCHED, GCAP, GAVAIL, GEXTRA) => #if GAVAIL <Int GEXTRA orBool Gstaticcalldepth << SCHED >> #then GCAP #else minInt(#allBut64th(GAVAIL -Int GEXTRA), GCAP) #fi

rule Csstore(SCHED, NEW, CURR, ORIG)
  => #if CURR ==Int NEW orBool ORIG =/=Int CURR #then Gsload < SCHED > #else #if ORIG ==Int 0 #then Gsstoreset < SCHED > #else Gsstorereset < SCHED > #fi #fi
  requires Ghasdirtysstore << SCHED >>

rule Csstore(SCHED, NEW, CURR, ORIG)
  => #if CURR ==Int 0 andBool NEW =/=Int 0 #then Gsstoreset < SCHED > #else Gsstorereset < SCHED > #fi
  requires notBool Ghasdirtysstore << SCHED >>

rule Rsstore(SCHED, NEW, CURR, ORIG) => #if CURR =/=Int 0 andBool NEW ==Int 0 #then Rsstoreclear < SCHED > #else 0 #fi
      requires notBool Ghasdirtysstore << SCHED >>

rule Cextra(SCHED, ISEMPTY, VALUE) => Gcall < SCHED > +Int Cnew(SCHED, ISEMPTY, VALUE) +Int Cxfer(SCHED, VALUE)

rule Cmem(SCHED, N) => (N *Int Gmemory < SCHED >) +Int ((N *Int N) /Int Gquadcoeff < SCHED >)

//Symbolic wrapper over the argument of #ecrec, no implementation.
syntax Int ::= #symEcrec ( WordStack ) [function]

rule <k> ECREC => #end EVMC_SUCCESS ... </k>
       <callData> DATA </callData>
       <output> _ => #ecrec(#symEcrec(DATA)) </output>
    requires notBool #isConcrete(DATA) andBool #sizeWordStack(DATA) ==Int 128
[trusted]

rule #memoryUsageUpdate(MU, START, WIDTH) => maxInt(MU, (START +Int WIDTH) up/Int 32) requires WIDTH  >Int 0

// GAS optimisation
rule ((A -Int (X +Int C)) +Int (C -Int Y)) => (A -Int X) -Int Y

rule #if C #then G -Int X #else G -Int Y #fi => G -Int (#if C #then X #else Y #fi)



// src/storage.k.md

syntax Int ::= "#DSGuard.acl" "[" Int "]" "[" Int "]" "[" Int "]" [function]
rule #DSGuard.acl[A][B][C] => #hashedLocation("Solidity", 3, A B C)

syntax Int ::= "#DSGuard.owner" [function]
rule #DSGuard.owner => 1

syntax Int ::= "#DSGuard.authority" [function]
rule #DSGuard.authority => 0 
// src/lemmas.k.md


endmodule
