with UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Vects; use  UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Vects;
with UxAS.Messages.Route.RouteConstraints.SPARK_Boundary; use  UxAS.Messages.Route.RouteConstraints.SPARK_Boundary;



package UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary with SPARK_Mode is
   
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   type My_RoutePlanRequest is private with
   Default_Initial_Condition => True;
   
   function Get_AssociatedTaskID
     (This : My_RoutePlanRequest) return Int64 with 
     Global => null;
   
   function Get_IsCostOnlyRequest
     (This : My_RoutePlanRequest) return Boolean with
     Global => null;
   
   function Get_OperatingRegion
     (This : My_RoutePlanRequest) return Int64 with
     Global => null;
   
   function Get_VehicleID
     (This : My_RoutePlanRequest) return Int64 with
     Global => null;
   
   function Get_RouteRequests
     (This : My_RoutePlanRequest) return Vect_My_RouteConstraints with
     Global => null,
       Post =>  (for all Ind_1 in First_Index (Get_RouteRequests'Result) .. Last_Index (Get_RouteRequests'Result)
                          => (for all Ind_2 in Ind_1 + 1 .. Last_Index (Get_RouteRequests'Result)
                              => (Get_RouteID (Element (Get_RouteRequests'Result, Ind_1)) /=
                                    Get_RouteID (Element (Get_RouteRequests'Result, Ind_2))))) 
   ;
   
   function Get_RequestID
     (This : My_RoutePlanRequest) return Int64 with
     Global => null;
   
   
   use  UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Vects.Vect_My_RouteConstraints_P;
   function Same_Requests (X, Y : My_RoutePlanRequest) return Boolean is
     (Get_AssociatedTaskID (X) = Get_AssociatedTaskID (Y)
      and Get_IsCostOnlyRequest (X) = Get_IsCostOnlyRequest (Y)
      and Get_OperatingRegion (X)   = Get_OperatingRegion (Y)
      and Get_VehicleID (X) = Get_VehicleID (Y)
      and Get_RequestID (X) = Get_RequestID (Y)
      and 
        (First_Index(Get_RouteRequests (X)) = First_Index(Get_RouteRequests (Y))
         and then Last_Index(Get_RouteRequests (X)) = Last_Index(Get_RouteRequests (Y))
         and then (for all I in First_Index(Get_RouteRequests (X)) .. Last_Index(Get_RouteRequests (X)) 
                   => (Element (Get_RouteRequests (X) , I) = Element (Get_RouteRequests (Y) , I))))); 
           
   pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
 
   overriding
   function "=" (X, Y : My_RoutePlanRequest) return Boolean;
   
   function Unwrap (This : My_RoutePlanRequest) return RoutePlanRequest with 
     Global => null,
     Inline,
     SPARK_Mode => Off; 

   function Wrap (This : RoutePlanRequest) return My_RoutePlanRequest with 
     Global => null,
     Inline,
     SPARK_Mode => Off; 
   
   procedure Set_AssociatedTaskID
     (This : in out My_RoutePlanRequest;
      AssociatedTaskID : Int64) with
     Post =>  Get_AssociatedTaskID (This) = AssociatedTaskID
     and Get_IsCostOnlyRequest (This) = Get_IsCostOnlyRequest (This'Old)
     and Get_OperatingRegion (This)   = Get_OperatingRegion (This'Old)
     and Get_VehicleID (This) = Get_VehicleID (This'Old)
     and Get_RequestID (This) = Get_RequestID (This'Old)
     and 
       (First_Index(Get_RouteRequests (This)) = First_Index(Get_RouteRequests (This'Old))
        and then Last_Index(Get_RouteRequests (This)) = Last_Index(Get_RouteRequests (This'Old))
        and then (for all I in First_Index(Get_RouteRequests (This)) .. Last_Index(Get_RouteRequests (This)) 
                  => Element (Get_RouteRequests (This) , I) = Element (Get_RouteRequests (This'Old) , I)));
   
   
   procedure Set_IsCostOnlyRequest
     (This : in out My_RoutePlanRequest;
      IsCostOnlyRequest : Boolean) with
     Post => Get_IsCostOnlyRequest (This) = IsCostOnlyRequest
     and Get_AssociatedTaskID (This) = Get_AssociatedTaskID (This'Old)
     and Get_OperatingRegion (This)   = Get_OperatingRegion (This'Old)
     and Get_VehicleID (This) = Get_VehicleID (This'Old)
     and Get_RequestID (This) = Get_RequestID (This'Old)
     and 
       (First_Index(Get_RouteRequests (This)) = First_Index(Get_RouteRequests (This'Old))
        and then Last_Index(Get_RouteRequests (This)) = Last_Index(Get_RouteRequests (This'Old))
        and then (for all I in First_Index(Get_RouteRequests (This)) .. Last_Index(Get_RouteRequests (This)) 
                  => Element (Get_RouteRequests (This) , I) = Element (Get_RouteRequests (This'Old) , I)));
   
     
   procedure Set_OperatingRegion
     (This : in out My_RoutePlanRequest;
      OperatingRegion : Int64) with
     Post => Get_OperatingRegion (This) = OperatingRegion
     and Get_AssociatedTaskID (This) = Get_AssociatedTaskID (This'Old)
     and Get_IsCostOnlyRequest (This) = Get_IsCostOnlyRequest (This'Old)
     and Get_VehicleID (This) = Get_VehicleID (This'Old)
     and Get_RequestID (This) = Get_RequestID (This'Old)
     and 
       (First_Index(Get_RouteRequests (This)) = First_Index(Get_RouteRequests (This'Old))
        and then Last_Index(Get_RouteRequests (This)) = Last_Index(Get_RouteRequests (This'Old))
        and then (for all I in First_Index(Get_RouteRequests (This)) .. Last_Index(Get_RouteRequests (This)) 
                  => Element (Get_RouteRequests (This) , I) = Element (Get_RouteRequests (This'Old) , I)));
   
      
   procedure Set_VehicleID
     (This : in out My_RoutePlanRequest;
      VehicleID : Int64) with
     Post =>  Get_VehicleID  (This) = VehicleID
     and Get_AssociatedTaskID  (This) = Get_AssociatedTaskID (This'Old)
     and Get_IsCostOnlyRequest (This) = Get_IsCostOnlyRequest (This'Old)
     and Get_OperatingRegion   (This)   = Get_OperatingRegion (This'Old)
     and Get_RequestID (This) = Get_RequestID (This'Old)
     and 
       (First_Index(Get_RouteRequests (This)) = First_Index(Get_RouteRequests (This'Old))
        and then Last_Index(Get_RouteRequests (This)) = Last_Index(Get_RouteRequests (This'Old))
        and then (for all I in First_Index(Get_RouteRequests (This)) .. Last_Index(Get_RouteRequests (This)) 
                  => Element (Get_RouteRequests (This) , I) = Element (Get_RouteRequests (This'Old) , I)));

   procedure Set_RequestID
     (This : in out My_RoutePlanRequest;
      RequestID : Int64) with
     Post =>  Get_RequestID  (This) = RequestID
     and Get_AssociatedTaskID  (This) = Get_AssociatedTaskID (This'Old)
     and Get_IsCostOnlyRequest (This) = Get_IsCostOnlyRequest (This'Old)
     and Get_OperatingRegion   (This)   = Get_OperatingRegion (This'Old)
     and GEt_VehicleID (This) = GEt_VehicleID (This'Old)
     and 
       (First_Index(Get_RouteRequests (This)) = First_Index(Get_RouteRequests (This'Old))
        and then Last_Index(Get_RouteRequests (This)) = Last_Index(Get_RouteRequests (This'Old))
        and then (for all I in First_Index(Get_RouteRequests (This)) .. Last_Index(Get_RouteRequests (This)) 
                  => Element (Get_RouteRequests (This) , I) = Element (Get_RouteRequests (This'Old) , I)));
   
    
   procedure Append_RouteRequests
     (This : in out My_RoutePlanRequest;
      RouteRequests : My_RouteConstraints) with
     Post =>  Element(Get_RouteRequests (This),
                      Last_Index (Get_RouteRequests (This)) ) = RouteRequests
     and Get_VehicleID  (This) = Get_VehicleID (This'Old)
     and Get_AssociatedTaskID  (This) = Get_AssociatedTaskID (This'Old)
     and Get_IsCostOnlyRequest (This) = Get_IsCostOnlyRequest (This'Old)
     and Get_OperatingRegion   (This)   = Get_OperatingRegion (This'Old)
     and Get_RequestID (This) = Get_RequestID (This'Old)
     and 
       (First_Index(Get_RouteRequests (This)) = First_Index(Get_RouteRequests (This'Old))
        and then Last_Index(Get_RouteRequests (This)) = Last_Index(Get_RouteRequests (This'Old))  + 1
        and then (for all I in First_Index(Get_RouteRequests (This'Old)) .. Last_Index(Get_RouteRequests (This'Old)) 
                  => Element (Get_RouteRequests (This) , I) = Element (Get_RouteRequests (This'Old) , I)));
   
      
  
      
private
   type My_RoutePlanRequest is record
      Content : RoutePlanRequest;
   end record;
   
   function Get_AssociatedTaskID
     (This : My_RoutePlanRequest) return Int64 is 
     (This.Content.GetAssociatedTaskID);
   
   function Get_IsCostOnlyRequest
     (This : My_RoutePlanRequest) return Boolean is 
     (This.Content.GetIsCostOnlyRequest);
   
   function Get_OperatingRegion
     (This : My_RoutePlanRequest) return Int64 is 
     (This.Content.GetOperatingRegion);
   
   function Get_VehicleID
     (This : My_RoutePlanRequest) return Int64 is 
     (This.Content.GetVehicleID);
  
   
   function Get_RequestID
     (This : My_RoutePlanRequest) return Int64 is
     (This.Content.GetRequestID);
   
   
   overriding 
   function "=" (X, Y : My_RoutePlanRequest) return Boolean is
     (X.Content = Y.Content); 
   
   function Unwrap (This : My_RoutePlanRequest) return RoutePlanRequest is 
     (This.Content) with 
     SPARK_Mode => Off;

   function Wrap (This : RoutePlanRequest) return My_RoutePlanRequest is
     (Content => This) with 
     SPARK_Mode => Off;
   

end UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary ;
