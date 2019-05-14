
package body UxAS.Messages.Route.RouteResponse.SPARK_Boundary with SPARK_Mode => Off is
   
   ------------------
   --  Get_Routes  --
   ------------------
   
   function Get_Routes 
     (This : My_RouteResponse) return Vect_My_RoutePlanResponse 
   is 
      L : constant UxAS.Messages.Route.RouteResponse.Vect_RoutePlanResponse_Acc_Acc :=
        THis.Content.GetRoutes;
   begin
      return R : Vect_My_RoutePlanResponse do
         for E of L.all loop
            Vect_My_RoutePlanResponse_V.Append(Container => R,
                                               New_Item  => Wrap(E.all));
         end loop;
      end return;
   end Get_Routes;

   
   ----------------------
   --  Set_ResponseID  --
   ----------------------
      
   procedure Set_ResponseID
     (This : in out My_RouteResponse;
      ResponseID : Int64) 
   is 
   begin
      This.Content.SetResponseID(ResponseID);
   end Set_ResponseID;
   
   
   -----------------
   --  Add_Route  --
   -----------------    
   procedure Add_Route
     (This : in Out My_RouteResponse;
      Route : My_RoutePlanResponse)
   is 
      RoutePlan_Acc : constant RoutePlanResponse_Acc := new RoutePlanResponse.RoutePlanResponse;
   begin
      RoutePlan_Acc.all := Unwrap(Route);
      This.Content.GetRoutes.Append(RoutePlan_Acc);
   end Add_Route;
   
   

end UxAS.Messages.Route.RouteResponse.SPARK_Boundary;
