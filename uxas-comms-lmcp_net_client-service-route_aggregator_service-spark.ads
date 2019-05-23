
with UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service; use UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service;
with UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary;         use UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary;
with UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Vects;   use UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Vects;
with Uxas.Messages.Route.RouteConstraints.SPARK_Boundary;         use Uxas.Messages.Route.RouteConstraints.SPARK_Boundary;
private
package UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK with SPARK_Mode is

   ------------------------------------------------
   -- Check of Route_Aggregator_Service Validity --
   ------------------------------------------------

   use all type Pair_Int64_Route_Plan_Map;
   use all type Route_Plan_Responses_Map;

   use all type Pending_Route_Matrix;
   function Check_Route_Plan    (This : Route_Aggregator_Service) return Boolean is
     (for all Cursor in This.Route_Plan
      =>(Key ( This.Route_Plan, Cursor) = Get_RouteID( Element (This.Route_Plan,
                                                                Cursor).Returned_Route_Plan)
         and Contains (This.Pending_Route, Element (This.Route_Plan,
                                                    Cursor).Reponse_ID)
         and Contains (This.Route_Plan_ResponseS,Element (This.Route_Plan,
                                                          Cursor).Reponse_ID)))
     with Ghost;
   use all type Task_Plan_Options_Map;
   function Check_Task_Plan_Options    (This : Route_Aggregator_Service) return Boolean is
     (for all Cursor in This.Task_Plan_Options
      => Key (This.Task_Plan_Options, Cursor) = Get_TaskID (Element (This.Task_Plan_Options,
                                                                     Cursor).Content))
     with Ghost;
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

   -------------------------------------------------
   -- Check of Route_Aggregator_Service evolution --
   -------------------------------------------------


   function Check_Same_Entity_State
     (X, Y : Entity_State_Map) return Boolean is
     (Int64_Entity_State_Maps.Formal_Model.M.Same_Keys
        (Int64_Entity_State_Maps.Formal_Model.Model (X),
         Int64_Entity_State_Maps.Formal_Model.Model (Y))
      and then (for all C of X
                => Same_Requests (Element (X, C).Content, Element (Y, C).Content)))
     with Ghost;
   procedure Lemma_Check_Same_Entity_State_Identity      (This    : in Entity_State_Map ) with Global => null,
     Post => Check_Same_Entity_State(This,This);
   procedure Lemma_Check_Same_Entity_State_Commutativity (X, Y    : in Entity_State_Map ) with Global => null,
     Pre => Check_Same_Entity_State(X,Y), Post => Check_Same_Entity_State(Y,X);
   procedure Lemma_Check_Same_Entity_State_Associativity (X, Y, Z : in Entity_State_Map ) with Global => null,
     Pre => Check_Same_Entity_State(X,Y) and Check_Same_Entity_State(Y,Z),  Post => Check_Same_Entity_State(X,Z);


   function Check_Same_Entity_Configuration
     (X, Y : Entity_Configuration_Map) return Boolean is
     (Int64_Entity_Configuration_Maps.Formal_Model.M.Same_Keys
        (Int64_Entity_Configuration_Maps.Formal_Model.Model (X),
         Int64_Entity_Configuration_Maps.Formal_Model.Model (Y))
      and then (for all C of X
                => Same_Requests (Element (X, C).Content, Element (Y, C).Content )))
     with Ghost;
   function Check_Same_Unique_Automation_Request
     (X, Y : Unique_Automation_Request_Map) return Boolean is
     (Int64_Unique_Automation_Request_Maps.Formal_Model.M.Same_Keys
        (Int64_Unique_Automation_Request_Maps.Formal_Model.Model (X),
         Int64_Unique_Automation_Request_Maps.Formal_Model.Model (Y))
      and then (for all C of X
                => Same_Requests (Element (X, C).Content, Element (Y, C).Content)))
     with Ghost;
   function Check_Same_Task_Plan_Options
     (X, Y : Task_Plan_Options_Map) return Boolean is
     (Int64_Task_Plan_Options_Maps.Formal_Model.M.Same_Keys
        (Int64_Task_Plan_Options_Maps.Formal_Model.Model (X),
         Int64_Task_Plan_Options_Maps.Formal_Model.Model (Y))
      and then (for all C of X
                => Same_Requests (Element (X, C).Content, Element (Y, C).Content)))
     with Ghost;
   function Check_Same_Route_Plan
     (X, Y : Pair_Int64_Route_Plan_Map) return Boolean is
     (Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Same_Keys
        (Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.Model (X),
         Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.Model (Y))
      and then (for all C of X
                => (Element (X, C).Reponse_ID   = Element (Y, C).Reponse_ID and
                      Same_Requests (Element (X, C).Returned_Route_Plan,Element (Y, C).Returned_Route_Plan))))
       with Ghost;
   function Check_Same_Pending_Auto_Req
     (X, Y : Pending_Auto_Req_Matrix) return Boolean is
     (Int64_Pending_Auto_Req_Matrix.Formal_Model.M.Same_Keys
        (Int64_Pending_Auto_Req_Matrix.Formal_Model.Model (X),
         Int64_Pending_Auto_Req_Matrix.Formal_Model.Model (Y))
      and then (for all C of X
                => (Element (X, C) = Element (Y, C))))
     with Ghost;
   function Check_Same_Route_Task_Pairing
     (X, Y : Aggregator_Task_Option_Pair_Map) return Boolean is
     (Int64_Aggregator_Task_Option_Pair_Maps.Formal_Model.M.Same_Keys
        (Int64_Aggregator_Task_Option_Pair_Maps.Formal_Model.Model (X),
         Int64_Aggregator_Task_Option_Pair_Maps.Formal_Model.Model (Y))
      and then (for all C of X
                => (Element (X, C).VehicleId = Element (Y, C).VehicleId
                    and Element (X, C).PrevTaskId = Element (Y, C).PrevTaskId
                    and Element (X, C).PrevTaskOption = Element (Y, C).PrevTaskOption
                    and Element (X, C).TaskId = Element (Y, C).TaskId
                    and Element (X, C).TaskOption = Element (Y, C).TaskOption)))
     with Ghost;
   function Check_Same_Route_Plan_Responses
     (X, Y : Route_Plan_Responses_Map) return Boolean is
     (Int64_Route_Plan_Responses_Maps.Formal_Model.M.Same_Keys
        (Int64_Route_Plan_Responses_Maps.Formal_Model.Model (X),
         Int64_Route_Plan_Responses_Maps.Formal_Model.Model (Y))
      and then (for all C of X
                => Same_Requests (Element (X, C).Content, Element (Y, C).Content)))
     with Ghost;
   function Check_Same_Pending_Route
     (X, Y : Pending_Route_Matrix) return Boolean is
     (Int64_Pending_Route_Matrix.Formal_Model.M.Same_Keys
        (Int64_Pending_Route_Matrix.Formal_Model.Model (X),
         Int64_Pending_Route_Matrix.Formal_Model.Model (Y))
      and then (for all C of X
                => (Element (X, C) = Element (Y, C))))
     with Ghost;

   function Same_Route_Aggretor
     (X , Y : Route_Aggregator_Service) return Boolean is
     (X.Fast_Plan = Y.Fast_Plan

      and Check_Same_Entity_State (X.Entity_State,Y.Entity_State)

      and Check_Same_Entity_Configuration (X.Entity_Configuration, Y.Entity_Configuration)

      and X.Ground_Vehicles = Y.Ground_Vehicles
      and X.Surface_Vehicles = Y.Surface_Vehicles
      and X.Air_Vehicules = Y.Air_Vehicules

      and X.Auto_Request_Id = Y.Auto_Request_Id

      and Check_Same_Unique_Automation_Request (X.Unique_Automation_Request, Y.Unique_Automation_Request)

      and Check_Same_Task_Plan_Options (X.Task_Plan_Options, Y.Task_Plan_Options)

      and X.Route_Id = Y.Route_Id

      and Check_Same_Route_Plan (X.Route_Plan, Y.Route_Plan)

      and Check_Same_Pending_Auto_Req (X.Pending_Auto_Req, Y.Pending_Auto_Req)

      and Check_Same_Route_Task_Pairing (X.Route_Task_Pairing, Y.Route_Task_Pairing)

      and X.Route_Request_ID = Y.Route_Request_ID

      and Check_Same_Route_Plan_Responses (X.Route_Plan_Responses, Y.Route_Plan_Responses)

      and Check_Same_Pending_Route (X.Pending_Route, Y.Pending_Route))  with Ghost;
   procedure Lemma_Same_Route_Aggregator_Validity
     (X, Y : in Route_Aggregator_Service ) with Global => null,
     Pre => Same_Route_Aggretor (X,Y) and All_Requests_Valid (X), Post => All_Requests_Valid (Y);
   procedure Lemma_Same_Route_Aggregator_Identity
     (This : in Route_Aggregator_Service ) with Post => Same_Route_Aggretor(This,This);
   procedure Lemma_Same_Route_Aggregator_Commutativity
     (X, Y : in Route_Aggregator_Service ) with Global => null,
     Pre => Same_Route_Aggretor(X,Y), Post => Same_Route_Aggretor(Y,X);
   procedure Lemma_Same_Route_Aggregator_Associativity
     (X, Y, Z : in Route_Aggregator_Service ) with Global => null,
     Pre => Same_Route_Aggretor(X,Y) and Same_Route_Aggretor(Y,Z),  Post => Same_Route_Aggretor(X,Z);





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

   use all type Vect_My_RouteConstraints;
   -- void EuclideanPlan(std::shared_ptr<uxas::messages::route::RoutePlanRequest>);
   procedure Euclidean_Plan (This               : in out Route_Aggregator_Service;
                             Route_Plan_Request : in My_RoutePlanRequest) with
     Pre => Int64_Route_Plan_Responses_Maps.Contains (This.Route_Plan_Responses,
                                                      Get_RequestID (Route_Plan_Request))
     and not Contains (This.Route_Plan_Responses, Get_RequestID (Route_Plan_Request))
     and (for all Id in First_Index (Get_RouteRequests (Route_Plan_Request)) ..  Last_Index (Get_RouteRequests (Route_Plan_Request))
          => not Contains (This.Route_Plan,
                           Get_RouteID ( Element (Get_RouteRequests (Route_Plan_Request),
                                                  ID))))
     and All_Requests_Valid (This)
     and Contains (This.Pending_Route,
                   Get_RequestID (Route_Plan_Request))



           ,

     Post => All_Requests_Valid (This)

     and Contains (This.Route_Plan_Responses,
                   Get_RequestID (Route_Plan_Request))

     and  (for all I in First_Index (Get_RouteRequests (Route_Plan_Request)) ..  Last_Index (Get_RouteRequests (Route_Plan_Request))
           => Contains (This.Route_Plan, Get_RouteID (Element (Get_RouteRequests (Route_Plan_Request), I))));


   --       and This.Fast_Plan = This.Fast_Plan'Old
   --
   --       and Check_Same_Entity_State (This.Entity_State,This.Entity_State'Old)
   --       and Check_Same_Entity_Configuration (This.Entity_Configuration, This.Entity_Configuration'Old)
   --
   --       and This.Ground_Vehicles = This.Ground_Vehicles'Old
   --       and This.Surface_Vehicles = This.Surface_Vehicles'Old
   --       and This.Air_Vehicules = This.Air_Vehicules'Old
   --
   --       and This.Auto_Request_Id = This.Auto_Request_Id'Old
   --       and Check_Same_Unique_Automation_Request (This.Unique_Automation_Request, This.Unique_Automation_Request'Old)
   --       and Check_Same_Task_Plan_Options (This.Task_Plan_Options, This.Task_Plan_Options'Old)
   --
   --       and This.Route_Id = This.Route_Id'Old
   --       and Check_Same_Pending_Auto_Req (This.Pending_Auto_Req, This.Pending_Auto_Req'Old)
   --       and Check_Same_Route_Task_Pairing (This.Route_Task_Pairing, This.Route_Task_Pairing'Old)
   --
   --       and This.Route_Request_ID = This.Route_Request_ID'Old
   --       and Check_Same_Pending_Route (This.Pending_Route, This.Pending_Route'Old);

   --  Void SendMatrix(Int64_T);
   procedure Send_Matrix (This    : in out Route_Aggregator_Service;
                          AutoKey : Int64) with
     Pre =>Contains (This.Pending_Auto_Req,
                     AutoKey)
     and then
       Contains (ThiS.Unique_Automation_Request,
                 AutoKey)
     and then
       (for all Response_ID of Element (Container => This.Pending_Auto_Req,
                                        Key       => AutoKey)
        => Contains (Container => This.Route_Plan,
                     Key       => Response_ID));


   --       Post => This.Route_Id   = This.Route_Id'Old
   --       and This.Fast_Plan  = This.Fast_Plan'Old
   --       and This.Route_Plan = This.Route_Plan'Old
   --       and This.Entity_State  = This.Entity_State'Old
   --       and This.Air_Vehicules = This.Air_Vehicules'Old
   --       and This.Pending_Route = This.Pending_Route'Old
   --       and This.Pending_Route = This.Pending_Route'Old
   --       and This.Ground_Vehicles = This.Ground_Vehicles'Old
   --       and This.Auto_Request_Id = This.Auto_Request_Id'Old
   --       and This.Surface_Vehicles = This.Surface_Vehicles'Old
   --       and This.Pending_Auto_Req = This.Pending_Auto_Req'Old
   --       and This.Route_Request_ID = This.Route_Request_ID'Old
   --       and This.Task_Plan_Options  = THis.Task_Plan_Options'Old
   --       and This.Route_Task_Pairing = This.Route_Task_Pairing'Old
   --       and This.Entity_Configuration = This.Entity_Configuration'Old
   --       and This.Route_Plan_Responses = This.Route_Plan_Responses'Old
   --       and This.Unique_Automation_Request = This.Unique_Automation_Request'Old;



end  UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK ;
