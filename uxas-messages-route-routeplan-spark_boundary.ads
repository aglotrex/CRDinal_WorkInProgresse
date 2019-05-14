package UxAS.Messages.Route.RoutePlan.SPARK_Boundary with SPARK_Mode is

   type My_RoutePlan is private with
   Default_Initial_Condition => True;
   
   function Get_RouteID
     (This : My_RoutePlan) return Int64 with
     Global => null;
   
   function Get_RouteCost
     (This : My_RoutePlan) return Int64 with
     Global => null;
   
     
   procedure Set_RouteID 
     (This : in out My_RoutePlan;
      RouteID : Int64) with 
     Global => null,
   Post => Get_RouteID (This) = RouteID 
     and Get_RouteCost (This) = Get_RouteCost (This'Old);
   
   procedure Set_RouteCost 
     (This : in out My_RoutePlan;
      RouteCost : Int64) with 
     Global => null,
   Post => Get_RouteCost (This) = RouteCost 
     and Get_RouteID (This) = Get_RouteID (This'Old);

   
   function Same_Requests (X, Y : My_RoutePlan) return Boolean is
     (Get_RouteID (X) = Get_RouteID (Y)
      and Get_RouteCost (X) = Get_RouteCost (Y) );
    
   
   pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
 
   overriding
   function "=" (X, Y : My_RoutePlan) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
   
   
   
 
   function Unwrap (This : My_RoutePlan) return RoutePlan;

   function Wrap (This : RoutePlan) return My_RoutePlan;
   
private 
   pragma SPARK_Mode (Off);
   type My_RoutePlan is record
      Content : RoutePlan;
   end record;
   
    
   function "=" (X, Y : My_RoutePlan) return Boolean is
      (X.Content = Y.Content);
   
   function Get_RouteID (This : My_RoutePlan) return Int64 is
     (THis.Content.GetRouteID);
   
   function Get_RouteCost (This : My_RoutePlan) return Int64 is
     (THis.Content.GetRouteCost);
   
   function Unwrap (This : My_RoutePlan) return RoutePlan is
     (This.Content);

   function Wrap (This : RoutePlan) return My_RoutePlan is
     (Content => This);
   
   

end UxAS.Messages.Route.RoutePlan.SPARK_Boundary;
