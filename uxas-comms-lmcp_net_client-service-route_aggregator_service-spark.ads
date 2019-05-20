
with UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service; use UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service;
with UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary; use UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary;


private
package UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK with SPARK_Mode is

   use all type Pair_Int64_Route_Plan_Map;
   function Check_Route_Plan    (This : Route_Aggregator_Service) return Boolean is
     (for all Cursor in This.Route_Plan
      => Key ( This.Route_Plan, Cursor) = Get_RouteID( Element (This.Route_Plan,
                                                                Cursor).Returned_Route_Plan))
     with Ghost;
   use all type Task_Plan_Options_Map;
   function Check_Task_Plan_Options    (This : Route_Aggregator_Service) return Boolean is
     (for all Cursor in This.Task_Plan_Options
      => Key (This.Task_Plan_Options, Cursor) = Get_TaskID (Element (This.Task_Plan_Options,
                                                                     Cursor).Content))
     with Ghost;
   use all type Route_Plan_Responses_Map;
   function Check_Route_Plan_Response  (This : Route_Aggregator_Service) return Boolean is
     (for all Cursor in This.Route_Plan_Responses
      => Key (This.Route_Plan_Responses, Cursor) = Get_ResponseID (Element (This.Route_Plan_Responses,
                                                                            Cursor).Content))
     with Ghost;

   use all type Unique_Automation_Request_Map;
   function Check_Unique_Automation_Request (This : Route_Aggregator_Service) return Boolean is
     ( for all Cursor in This.Unique_Automation_Request
      => Key (This.Unique_Automation_Request, Cursor) < This.Auto_Request_Id)
       with Ghost;

   use all type Entity_State_Map;
   use all type Int64_Set;
   function Check_Entity_State  (This : Route_Aggregator_Service) return Boolean is
     (for all Cursor in This.Entity_State
      =>( -- check ID value
         Key (This.Entity_State, Cursor) = Get_ID (Element (This.Entity_State,
                                                            Cursor).Content)
         and
         -- check type identification
           (Contains (This.Air_Vehicules, Key (This.Entity_State, Cursor))
            xor
              Contains (This.Ground_Vehicles, Key (This.Entity_State, Cursor))
            xor
              Contains (This.Surface_Vehicles, Key (This.Entity_State, Cursor)))))
       with Ghost;

   use all type Entity_Configuration_Map;

   function Check_Entity_Configuration (This : Route_Aggregator_Service) return Boolean is
     (for all Cursor in This.Entity_Configuration
      =>( -- check ID value
         Key (This.Entity_Configuration, Cursor) = Get_ID (Element (This.Entity_Configuration,
                                                                    Cursor).Content)
         and
         -- check type identification
           (Contains (This.Air_Vehicules, Key (This.Entity_Configuration, Cursor))
            xor
              Contains (This.Ground_Vehicles, Key (This.Entity_Configuration, Cursor))
            xor
              Contains ( This.Surface_Vehicles, Key (This.Entity_Configuration, Cursor)))))
       with Ghost;

   use all type Pending_Route_Matrix;
   function Check_Pending_Route (This : Route_Aggregator_Service) return Boolean is
     (for all Cursor_Request_ID_1 in This.Pending_Route
      => (for all Cursor_Route_Plan_1 in Element (This.Pending_Route, Cursor_Request_ID_1)
          => ( -- check ID value
              This.Route_Id > Element (Element (This.Pending_Route, Cursor_Request_ID_1) , Cursor_Route_Plan_1)
              and

              -- check id unicity in other set
                (for all Cursor_Request_ID_2 in This.Pending_Route
                 =>( if Key (This.Pending_Route, Cursor_Request_ID_1) /= Key (This.Pending_Route, Cursor_Request_ID_2) then
                      not Contains (Element (This.Pending_Route, Cursor_Request_ID_2),
                                    Element (Element (This.Pending_Route, Cursor_Request_ID_1) , Cursor_Route_Plan_1)))))))
     with Ghost;

   use all type Pending_Auto_Req_Matrix;
   use all type Aggregator_Task_Option_Pair_Map;

   function Check_List_Pending_Request (This : Route_Aggregator_Service) return Boolean is
     (for all Cursor_Request_ID_1 in This.Pending_Auto_Req
      => (-- check id
          Contains (This.Unique_Automation_Request,
                      Key (This.Pending_Auto_Req, Cursor_Request_ID_1))

          and

            (for all Cursor_Response_ID_1 in Element (This.Pending_Auto_Req, Cursor_Request_ID_1)
             => (-- check valide ID
                 This.Route_Request_ID > Element (Element (This.Pending_Auto_Req, Cursor_Request_ID_1), Cursor_Response_ID_1)
                 and

                 -- check it reference well a Route task pairing
                   Contains (This.Route_Task_Pairing,
                             Element (Element (This.Pending_Auto_Req, Cursor_Request_ID_1), Cursor_Response_ID_1))

                 and

                 -- check ID unicity over other set
                   (for all Cursor_Request_ID_2 in This.Pending_Auto_Req
                    =>( if Key (This.Pending_Auto_Req, Cursor_Request_ID_1) /= Key (This.Pending_Auto_Req, Cursor_Request_ID_2) then
                         not Contains (Element (This.Pending_Auto_Req, Cursor_Request_ID_2),
                                       Element (Element (This.Pending_Auto_Req, Cursor_Request_ID_1) , Cursor_Response_ID_1))))))))
     with Ghost;


   function Check_Route_Task_Pairing (This : Route_Aggregator_Service) return Boolean is
     (for all Cursor in This.Route_Task_Pairing
      => (-- check id
          This.Route_Request_ID > Key (This.Route_Task_Pairing, Cursor)

          and
          -- check Vehicles ID of Aggregator
            Contains (This.Entity_State,
                      Element (This.Route_Task_Pairing, Cursor).VehicleId)))
       with Ghost;


   use all type Int64_Vect;

   function All_Requests_Valid
     (This : Route_Aggregator_Service) return Boolean is
     (Check_Route_Plan (This)
      and Check_Entity_State  (This)
      and Check_Pending_Route (This)
      and Check_Task_Plan_Options    (This)
      and Check_Route_Task_Pairing   (This)
      and Check_Route_Plan_Response  (This)
      and Check_Entity_Configuration (This)
      and Check_List_Pending_Request (This)
      and Check_Unique_Automation_Request (This)) with Ghost;


   procedure Build_Matrix_Requests (This  : in out Route_Aggregator_Service;
                                    ReqID : in Int64;
                                    Areq  : in My_UniqueAutomationRequest) with
     Pre => not Int64_Pending_Auto_Req_Matrix.Contains(This.Pending_Auto_Req,
                                                       ReqID),
     Post => This.Unique_Automation_Request'Old = This.Unique_Automation_Request;

   -- void SendRouteResponse(int64_t);
   procedure Send_Route_Reponse (This     : in out Route_Aggregator_Service;
                                 RouteKey : Int64) with
     Pre =>
       Int64_Pending_Route_Matrix.Contains(This.Pending_Route,
                                           RouteKey)
     and then
       (for all Cursor in Element (This.Pending_Route, RouteKey)
        =>( -- check of calculation
                 Contains (This.Route_Plan_Responses,
                           Element (Element (This.Pending_Route, RouteKey), Cursor))
           and then
             (for all J in  First_Index (Get_ID_From_RouteResponses ( Element (This.Route_Plan_Responses,
                                                                               Element (Element (This.Pending_Route, RouteKey) , Cursor)).Content)) ..
                Last_Index (Get_ID_From_RouteResponses ( Element (This.Route_Plan_Responses,
                                                                  Element (Element (This.Pending_Route, RouteKey) , Cursor)).Content))
              => Contains (This.Route_Plan,
                           Element ( Get_ID_From_RouteResponses ( Element (This.Route_Plan_Responses,
                                                                           Element (Element (This.Pending_Route, RouteKey) , Cursor)).Content),J)))))
     ,
     Post => ( Int64_Pending_Route_Matrix.Contains(This.Pending_Route,
               RouteKey)
               and This.Pending_Route = This.Pending_Route'Old);



   -- void CheckAllRoutePlans();
   procedure Check_All_Route_Plans (This : in out Route_Aggregator_Service);


   --  void CheckAllTaskOptionsReceived();
   procedure Check_All_Task_Option_Received (This : in out Route_Aggregator_Service);



   -- For each vehicle target by Route_Resquest generate a corresponding My_RoutePlanRequests
   --   (and initiate calculationin function of the vehicles types)
   --
   --
   -- void HandleRouteRequest(std::shared_ptr<uxas::messages::route::RouteRequest>);
   procedure Handle_Route_Request (This          : in out Route_Aggregator_Service;
                                   Route_Request : My_RouteRequest) with
     Pre => Contains (Container => This.Pending_Route,
                      Key       => Get_RequestID (Route_Request)) ;


   -- void EuclideanPlan(std::shared_ptr<uxas::messages::route::RoutePlanRequest>);
   procedure Euclidean_Plan (This               : in out Route_Aggregator_Service;
                             Route_Plan_Request : in My_RoutePlanRequest) with
     Pre => Int64_Route_Plan_Responses_Maps.Contains (This.Route_Plan_Responses,
                                                      Get_RequestID (Route_Plan_Request));

   --  Void SendMatrix(Int64_T);
   procedure Send_Matrix (This    : in out Route_Aggregator_Service;
                          AutoKey : Int64) with
     Pre =>Contains (This.Pending_Auto_Req,
                     AutoKey)
     and
       (for all Response_ID of Element (Container => This.Pending_Auto_Req,
                                        Key       => AutoKey)
        => Contains (Container => This.Route_Plan,
                     Key       => Response_ID))
     and
       Contains (ThiS.Unique_Automation_Request,
                 AutoKey)
   ;


end  UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK ;
