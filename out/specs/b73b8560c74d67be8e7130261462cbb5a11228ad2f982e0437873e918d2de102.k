requires "../rules.k"
requires "../bin_runtime.k"


module B73B8560C74D67BE8E7130261462CBB5A11228AD2F982E0437873E918D2DE102
  imports ETHEREUM-SIMULATION
  imports EVM
  imports RULES
  imports BIN_RUNTIME
  

// DSGuard_permit-auth
rule [DSGuard.permit-auth.pass.rough]:
  <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
  <exit-code> 1 </exit-code>
  <mode> NORMAL </mode>
  <schedule> PETERSBURG </schedule>
  <ethereum>
    <evm>
      <output> .WordStack </output>
      <statusCode> _ => EVMC_SUCCESS </statusCode>
      <callStack> VCallStack </callStack>
      <interimStates> _ </interimStates>
      <touchedAccounts> _ => _ </touchedAccounts>
      <callState>
        <program> #asMapOpCodes(#dasmOpCodes(DSGuard_bin_runtime, PETERSBURG)) </program>
        <programBytes> DSGuard_bin_runtime </programBytes>
        <id> ACCT_ID </id>
        <caller> CALLER_ID </caller>
        <callData> #abiCallData("permit", #bytes32(ABI_src), #bytes32(ABI_dst), #bytes32(ABI_sig)) ++ CD => _ </callData>
        <callValue> VCallValue </callValue>
        <wordStack> .WordStack => _ </wordStack>
        <localMem> .Map => _ </localMem>
        <pc> 0 => _ </pc>
        <gas> VGas => _ </gas>
        <memoryUsed> 0 => _ </memoryUsed>
        <callGas> _ => _ </callGas>
        <static> false </static>
        <callDepth> VCallDepth </callDepth>
      </callState>
      <substate>
        <selfDestruct> VSelfDestruct </selfDestruct>
        <log> _ => VLog </log>
        <refund> _ => VRefund </refund>
      </substate>
      <gasPrice> _ </gasPrice>
      <origin> ORIGIN_ID </origin>
      <previousHash> _ </previousHash>
      <ommersHash> _ </ommersHash>
      <coinbase> _ </coinbase>
      <stateRoot> _ </stateRoot>
      <transactionsRoot> _ </transactionsRoot>
      <receiptsRoot> _ </receiptsRoot>
      <logsBloom> _ </logsBloom>
      <difficulty> _ </difficulty>
      <number> _ </number>
      <gasLimit> _ </gasLimit>
      <gasUsed> _ </gasUsed>
      <timestamp> TIME </timestamp>
      <extraData> _ </extraData>
      <mixHash> _ </mixHash>
      <blockNonce> _ </blockNonce>
      <ommerBlockHeaders> _ </ommerBlockHeaders>
      <blockhash> _ </blockhash>
    </evm>
    <network>
      <activeAccounts> SetItem(ACCT_ID)
      SetItem(1)
      SetItem(2)
      SetItem(3)
      SetItem(4)
      SetItem(5)
      SetItem(6)
      SetItem(7)
      SetItem(8) _ </activeAccounts>
      <accounts>
        <account>
          <acctID> ACCT_ID </acctID>
          <balance> ACCT_ID_balance </balance>
          <code> DSGuard_bin_runtime </code>
          <storage>         
           .Map 
          [#DSGuard.acl[ABI_src][ABI_dst][ABI_sig] <- (Approval => true)]        
          [#DSGuard.owner <- (Owner    => Owner)]
            _:Map 
           </storage>
          <origStorage> _ </origStorage>
          <nonce> _ </nonce>
        </account>
       ... 
      </accounts>
      <txOrder> _ </txOrder>
      <txPending> _ </txPending>
      <messages> _ </messages>
    </network>
  </ethereum>
requires #rangeAddress(ACCT_ID)
andBool #notPrecompileAddress(ACCT_ID)
andBool #rangeAddress(CALLER_ID)
andBool #rangeAddress(ORIGIN_ID)
andBool #rangeUInt(256, TIME)
andBool #rangeUInt(256, ACCT_ID_balance)
andBool VCallDepth <=Int 1024
andBool #rangeUInt(256, VCallValue)

  andBool (#rangeBytes(32, ABI_src)
  andBool (#rangeBytes(32, ABI_dst)
  andBool (#rangeBytes(32, ABI_sig)
  andBool (#rangeUInt(1, Approval)
  andBool (#rangeAddress(Owner)
  andBool (#rangeAddress(Authority)
  andBool ((#sizeWordStack(CD) <=Int 1250000000)
  andBool ((#notPrecompileAddress(Owner))
  andBool ((#notPrecompileAddress(Authority))
  andBool ((CALLER_ID ==Int Owner)
  andBool (VGas >=Int 3000000
  andBool ((VCallValue ==Int 0))))))))))))) 

endmodule
