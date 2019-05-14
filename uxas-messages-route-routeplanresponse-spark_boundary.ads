with Common_Formal_Containers; use Common_Formal_Containers;
with UxAS.Messages.Route.RoutePlan;

package UxAS.Messages.Route.RoutePlanResponse.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   type My_RoutePlanResponse is private with
   Default_Initial_Condition => True;
   
    use all type Int64_Vect;
   
   function Get_ResponseID
     (This : My_RoutePlanResponse) return Int64 with 
     Global => null;
   
   function Get_AssociatedTaskID
     (This : My_RoutePlanResponse) return Int64 with 
     Global => null;
   
   function Get_VehicleID
     (This : My_RoutePlanResponse) return Int64 with 
     Global => null;
   
   function Get_OperatingRegion
     (This : My_RoutePlanResponse) return Int64 with 
     Global => null;
   
   function Get_ID_From_RouteResponses
     (This : My_RoutePlanResponse) return Int64_Vect with
     Global => null;
   
   function Same_Requests (X, Y : My_RoutePlanResponse) return Boolean is
     (Get_ResponseID (X) = Get_ResponseID (Y)
      and Get_AssociatedTaskID (X) = Get_AssociatedTaskID (Y)
      and Get_VehicleID (X) = Get_VehicleID (Y)
      and Get_OperatingRegion (X) = Get_OperatingRegion (Y)
      and (First_Index(Get_ID_From_RouteResponses (X)) = First_Index(Get_ID_From_RouteResponses (Y)) 
           and then Last_Index(Get_ID_From_RouteResponses (X)) = Last_Index(Get_ID_From_RouteResponses (Y))
           and then (for All I in First_Index(Get_ID_From_RouteResponses (X)) .. Last_Index(Get_ID_From_RouteResponses (X))
                     => Element (Get_ID_From_RouteResponses (X), I) = Element (Get_ID_From_RouteResponses (Y) , I))));
   pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
   
   procedure Set_ResponseID
     (This : in out My_RoutePlanResponse;
      ResponseID : Int64) with 
     Post => Get_ResponseID (This) = ResponseID
     and Get_AssociatedTaskID (This) = Get_AssociatedTaskID (This'Old)
     and Get_VehicleID (This) = Get_VehicleID (This'Old)
     and Get_OperatingRegion (This) = Get_OperatingRegion (This'Old)
     and (First_Index(Get_ID_From_RouteResponses (This)) = First_Index(Get_ID_From_RouteResponses (This'Old)) 
          and then Last_Index(Get_ID_From_RouteResponses (This)) = Last_Index(Get_ID_From_RouteResponses (This'Old))
          and then (for all I in First_Index(Get_ID_From_RouteResponses (This)) .. Last_Index(Get_ID_From_RouteResponses (This))
                    => Element (Get_ID_From_RouteResponses (This), I) = Element (Get_ID_From_RouteResponses (This'Old) , I)));
   

   procedure Set_AssociatedTaskID
     (This : in out My_RoutePlanResponse;
      AssociatedTaskID : Int64) with 
     Post => Get_AssociatedTaskID (This) = AssociatedTaskID
     and Get_ResponseID (This) = Get_ResponseID (This'Old)
     and Get_VehicleID (This) = Get_VehicleID (This'Old)
     and Get_OperatingRegion (This) = Get_OperatingRegion (This'Old)
     and (First_Index(Get_ID_From_RouteResponses (This)) = First_Index(Get_ID_From_RouteResponses (This'Old)) 
          and then Last_Index(Get_ID_From_RouteResponses (This)) = Last_Index(Get_ID_From_RouteResponses (This'Old))
          and then (for all I in First_Index(Get_ID_From_RouteResponses (This)) .. Last_Index(Get_ID_From_RouteResponses (This))
                    => Element (Get_ID_From_RouteResponses (This), I) = Element (Get_ID_From_RouteResponses (This'Old) , I)));
   
   procedure Set_VehicleID
     (This : in out My_RoutePlanResponse;
      VehicleID : Int64) with 
     Post => Get_VehicleID (This) = VehicleID
     and Get_AssociatedTaskID (This) = Get_AssociatedTaskID (This'Old)
     and Get_ResponseID (This) = Get_ResponseID (This'Old)
     and Get_OperatingRegion (This) = Get_OperatingRegion (This'Old)
     and (First_Index(Get_ID_From_RouteResponses (This)) = First_Index(Get_ID_From_RouteResponses (This'Old)) 
          and then Last_Index(Get_ID_From_RouteResponses (This)) = Last_Index(Get_ID_From_RouteResponses (This'Old))
          and then (for all I in First_Index(Get_ID_From_RouteResponses (This)) .. Last_Index(Get_ID_From_RouteResponses (This))
                    => Element (Get_ID_From_RouteResponses (This), I) = Element (Get_ID_From_RouteResponses (This'Old) , I)));
   
  
   procedure Set_OperatingRegion
     (This : in out My_RoutePlanResponse;
      OperatingRegion : Int64) with 
     Post => Get_OperatingRegion (This) = OperatingRegion
     and Get_AssociatedTaskID (This) = Get_AssociatedTaskID (This'Old)
     and Get_ResponseID (This) = Get_ResponseID (This'Old)
     and Get_VehicleID (This) = Get_VehicleID (This'Old)
     and (First_Index(Get_ID_From_RouteResponses (This)) = First_Index(Get_ID_From_RouteResponses (This'Old)) 
          and then Last_Index(Get_ID_From_RouteResponses (This)) = Last_Index(Get_ID_From_RouteResponses (This'Old))
          and then (for all I in First_Index(Get_ID_From_RouteResponses (This)) .. Last_Index(Get_ID_From_RouteResponses (This))
                    => Element (Get_ID_From_RouteResponses (This), I) = Element (Get_ID_From_RouteResponses (This'Old) , I)));
   
   
   overriding
   function "=" (X, Y : My_RoutePlanResponse) return Boolean with 
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
   
   function Unwrap (This : My_RoutePlanResponse) return RoutePlanResponse;

   function Wrap (This : RoutePlanResponse) return My_RoutePlanResponse;
   
private
   pragma SPARK_Mode(Off);
   type My_RoutePlanResponse is record
      Content : RoutePlanResponse;
   end record;
   
   function Get_ResponseID
     (This : My_RoutePlanResponse) return Int64 is 
     (This.Content.GetResponseID);
   
   function Get_AssociatedTaskID
     (This : My_RoutePlanResponse) return Int64 is
     (This.Content.GetAssociatedTaskID);
   
   function Get_VehicleID
     (This : My_RoutePlanResponse) return Int64 is 
     (This.Content.GetVehicleID);
   
   function Get_OperatingRegion
     (This : My_RoutePlanResponse) return Int64 is
     (This.Content.GetOperatingRegion);
   
   overriding 
   function "=" (X, Y : My_RoutePlanResponse) return Boolean is
     (X.Content = Y.Content); 
   
   function Unwrap (This : My_RoutePlanResponse) return RoutePlanResponse is 
     (This.Content);

   function Wrap (This : RoutePlanResponse) return My_RoutePlanResponse is
     (Content => This);

end UxAS.Messages.Route.RoutePlanResponse.SPARK_Boundary;
