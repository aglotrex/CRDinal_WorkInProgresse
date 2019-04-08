package UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK is

   type AggregatorTaskOptionPair is record
      vehicleId      : Int64 := 0;
      prevTaskId     : Int64 := 0;
      prevTaskOption : Int64 := 0;
      taskId         : Int64 := 0;
      taskOption     : Int64 := 0;
   end record;

end  UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK ;
