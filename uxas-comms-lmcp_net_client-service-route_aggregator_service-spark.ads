with UxAS.Messages.Route.RouteRequest.SPARK_Boundary; use UxAS.Messages.Route.RouteRequest.SPARK_Boundary;



with UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service; use UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service;



private
package UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK with SPARK_Mode is

   --     --  Void SendMatrix(Int64_T);
   --     procedure Send_Matrix( This : in out Route_Aggregator_Service;
   --                            AutoKey : Int64);


   --    -- void SendRouteResponse(int64_t);
   --    procedure Send_Route_Reponse ( This : in out Route_Aggregator_Service;
   --                                   RouteKey : Int64);

   --
   --     -- void CheckAllRoutePlans();
   --     procedure Check_All_Route_Plans(This : in out Route_Aggregator_Service);
   --
   --       --  void CheckAllTaskOptionsReceived();
   --     procedure Check_All_Task_Option_Received(This : in out Route_Aggregator_Service);
   --
   --     -- void HandleRouteRequest(std::shared_ptr<uxas::messages::route::RouteRequest>);
   --     procedure Handle_Route_Request(This         : in out Route_Aggregator_Service;
   --                                    Route_Request : RouteRequest_Acc);
   --
   --


   -- void EuclideanPlan(std::shared_ptr<uxas::messages::route::RoutePlanRequest>);
   procedure Euclidean_Plan(This             : in out Route_Aggregator_Service;
                            Route_Plan_Request : RoutePlanRequest);


end  UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK ;
