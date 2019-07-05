`DSGuard` spec

```act
behaviour owner of DSGuard
interface owner()

types
  Owner : address

storage
  owner |-> Owner

iff
  VCallValue == 0

returns Owner
```

```act
behaviour canCall of DSGuard
interface canCall(address src, address dst, bytes4 sig)



returns 1
```

```act
behaviour permit-address-owner of DSGuard
interface permit(address src, address dst, bytes32 sig)

types
  Approval  : bool
  Owner     : address
  Authority : address

storage
  acl[src][dst][sig] |-> Approval => true  
  owner |-> Owner
  authority |-> Authority	

iff
  VCallValue == 0

if
  CALLER_ID == Owner
  ACCT_ID =/= CALLER_ID
```
