```k
syntax Int ::= "#DSGuard.acl" "[" Int "]" "[" Int "]" "[" Int "]" [function]
rule #DSGuard.acl[A][B][C] => #hashedLocation("Solidity", 3, A B C)
```
