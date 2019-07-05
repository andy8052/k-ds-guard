requires "../rules.k"
requires "../bin_runtime.k"


module 7BB6D47BD94D47704C88B7019B98923DC473C8EF22AA98DA4C2F2EEF12DF3486
  imports ETHEREUM-SIMULATION
  imports EVM
  imports RULES
  imports BIN_RUNTIME
  

// DSGuard__exhaustiveness
rule [DSGuard..exhaustiveness]:
  <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
  <exit-code> 1 </exit-code>
  <mode> NORMAL </mode>
  <schedule> PETERSBURG </schedule>
  <ethereum>
    <evm>
      <output> _ => VOutput </output>
      <statusCode> _ => EVMC_REVERT_NETWORK </statusCode>
      <callStack> VCallStack </callStack>
      <interimStates> _ </interimStates>
      <touchedAccounts> _ => _ </touchedAccounts>
      <callState>
        <program> #asMapOpCodes(#dasmOpCodes(DSGuard_bin_runtime, PETERSBURG)) </program>
        <programBytes> DSGuard_bin_runtime </programBytes>
        <id> ACCT_ID </id>
        <caller> CALLER_ID </caller>
        <callData> VCallData </callData>
        <callValue> VCallValue </callValue>
        <wordStack> .WordStack => _ </wordStack>
        <localMem> .Map => _ </localMem>
        <pc> 0 => _ </pc>
        <gas> VGas => _ </gas>
        <memoryUsed> 0 => _ </memoryUsed>
        <callGas> _ => _ </callGas>
        <static> _ </static>
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
      <activeAccounts> VActiveAccounts </activeAccounts>
      <accounts> _ </accounts>
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
andBool 330252341 =/=Int chop(#asWord(#take(4, #take(32, VCallData))))
andBool 734208381 =/=Int chop(#asWord(#take(4, #take(32, VCallData))))
andBool 2044235143 =/=Int chop(#asWord(#take(4, #take(32, VCallData))))
andBool 2057199179 =/=Int chop(#asWord(#take(4, #take(32, VCallData))))
andBool 2376452955 =/=Int chop(#asWord(#take(4, #take(32, VCallData))))
andBool 2824089446 =/=Int chop(#asWord(#take(4, #take(32, VCallData))))
andBool 3070268947 =/=Int chop(#asWord(#take(4, #take(32, VCallData))))
andBool 3212714319 =/=Int chop(#asWord(#take(4, #take(32, VCallData))))
andBool 3421415052 =/=Int chop(#asWord(#take(4, #take(32, VCallData))))
andBool 4028726501 =/=Int chop(#asWord(#take(4, #take(32, VCallData))))andBool VGas >=Int 40000000 

endmodule
