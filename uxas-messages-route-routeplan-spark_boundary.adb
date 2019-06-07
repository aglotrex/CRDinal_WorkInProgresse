package body UxAS.Messages.Route.RoutePlan.SPARK_Boundary with SPARK_Mode => Off is
   

   procedure Lemmma_Equal_RoutePlan (X,Y : in My_RoutePlan) is null;
   
   -------------------
   --  Set_RouteID  --
   -------------------
   
   procedure Set_RouteID 
     (This : in out My_RoutePlan;
      RouteID : Int64) 
   is
   begin
      This.Content.SetRouteID (RouteID);
   end Set_RouteID; 
   
   
   ---------------------
   --  Set_RouteCost  --
   ---------------------
   
   procedure Set_RouteCost 
     (This : in out My_RoutePlan;
      RouteCost : Int64) 
   is
   begin
      This.Content.SetRouteCost (RouteCost);
   end Set_RouteCost; 
   

   
end UxAS.Messages.Route.RoutePlan.SPARK_Boundary;
