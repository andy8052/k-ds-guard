`DSGuard` spec

```act
behaviour canCall of DSGuard
interface canCall(address src, address dst, bytes4 sig)



returns 1
```

```act
behaviour permit-auth of DSGuard
interface permit(bytes32 src, bytes32 dst, bytes32 sig)

types
  Approval : bool
  Owner    : address

storage
  acl[src][dst][sig] |-> Approval => true  

if
  CALLER_ID == Owner
```
