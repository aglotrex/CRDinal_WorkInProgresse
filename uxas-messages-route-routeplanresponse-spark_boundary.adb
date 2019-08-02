with UxAS.Messages.Route.RoutePlan;
package body UxAS.Messages.Route.RoutePlanResponse.SPARK_Boundary with SPARK_Mode => Off is
   
   ----------------------------------
   --  Get_ID_From_RouteResponses  --
   ----------------------------------
   
   function Get_ID_From_RouteResponses
     (This : My_RoutePlanResponse) return Int64_Vect 
   is 
      L : constant UxAS.Messages.Route.RoutePlanResponse.Vect_RoutePlan_Acc_Acc :=
        This.Content.GetRouteResponses;
   begin
      return R : Int64_Vect do
         for E of L.all loop
            Int64_Vects.Append(Container => R,
                               New_Item  => E.GetRouteID);
         end loop;
      end return;
   end Get_ID_From_RouteResponses;
   
   ----------------------
   --  Set_ResponseID  --
   ----------------------
   
   procedure Set_ResponseID
     (This : in out My_RoutePlanResponse;
      ResponseID : Int64) 
   is
   begin
      This.Content.SetResponseID(ResponseID);
   end Set_ResponseID;
   
   ----------------------------
   --  Set_AssociatedTaskID  --
   ----------------------------
   
   procedure Set_AssociatedTaskID
     (This : in out My_RoutePlanResponse;
      AssociatedTaskID : Int64) 
   is
   begin
      This.Content.SetAssociatedTaskID(AssociatedTaskID);
   end Set_AssociatedTaskID;
   
   
   ---------------------
   --  Set_VehicleID  --
   ---------------------
    
   procedure Set_VehicleID
     (This : in out My_RoutePlanResponse;
      VehicleID : Int64) 
   is
   begin
      This.Content.SetVehicleID(VehicleID);
   end Set_VehicleID;
   
   ---------------------------
   --  Set_OperatingRegion  --
   ---------------------------
   
   procedure Set_OperatingRegion
     (This : in out My_RoutePlanResponse;
      OperatingRegion : Int64) 
   is
   begin
      This.Content.SetOperatingRegion(OperatingRegion);
   end Set_OperatingRegion;
   
   --------------------------
   --  Set_RouteResponses  --
   --------------------------
   
   procedure Set_ID_From_RouteResponses
     (This             : in out  My_RoutePlanResponse;
      RoutePlanRequest : in Vect_My_RouteConstraints)
   is
   begin
      Vect_RoutePlan_Acc.Clear (This.Content.RouteResponses.all);
      for E of RoutePlanRequest loop
         declare 
            New_Route_Plan : constant RoutePlan_Acc := new RoutePlan.RoutePlan;
         begin
            SetRouteID (New_Route_Plan.all, (Get_RouteID (E)));
            Vect_RoutePlan_Acc.Append (This.Content.RouteResponses.all, New_Route_Plan);
         end;
      end loop;
   end Set_ID_From_RouteResponses;
 

end UxAS.Messages.Route.RoutePlanResponse.SPARK_Boundary;
