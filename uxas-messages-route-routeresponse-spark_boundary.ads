with Ada.Containers.Formal_Vectors;
with uxas.messages.route.RoutePlanResponse;
with uxas.messages.route.RoutePlanResponse.SPARK_Boundary; use uxas.messages.route.RoutePlanResponse.SPARK_Boundary;

package uxas.Messages.Route.RouteResponse.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   package Vect_My_RoutePlanResponse_V is new Ada.Containers.Formal_Vectors
     (Index_Type   => Natural,
      Element_Type => My_RoutePlanResponse,
      "="          => uxas.messages.route.RoutePlanResponse.SPARK_Boundary."=");
   use Vect_My_RoutePlanResponse_V;

   Vect_My_RoutePlanResponse_Commun_Max_Capacity : constant := 200; -- arbitrary

   subtype Vect_My_RoutePlanResponse is Vect_My_RoutePlanResponse_V.Vector
     (Vect_My_RoutePlanResponse_Commun_Max_Capacity);

   type My_RouteResponse is private with
     Default_Initial_Condition => True;

   function Get_Routes
     (This : My_RouteResponse) return Vect_My_RoutePlanResponse with
     Global => null;

   function Get_ResponseID
     (This : My_RouteResponse) return Int64 with
     Global => null,
     Annotate => (GNATprove,Terminating);

   function Same_Requests (X, Y : My_RouteResponse) return Boolean is
     (Get_ResponseID (X) = Get_ResponseID (Y)
      and (First_Index (Get_Routes (X)) = First_Index (Get_Routes (Y))
           and then Last_Index (Get_Routes (X)) = Last_Index (Get_Routes (Y))
           and then (for all I  in First_Index (Get_Routes (X)) .. Last_Index (Get_Routes (X))
                     => Element (Get_Routes (X), I) = Element (Get_Routes (Y), I))));
   --  pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);

   overriding function "=" (X, Y : My_RouteResponse) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y)),
     Annotate => (GNATprove,Terminating);

   procedure Set_ResponseID
     (This : in out My_RouteResponse;
      ResponseID : Int64) with
     Global => null,
     Post => Get_ResponseID (This) = ResponseID
     and  (First_Index (Get_Routes (This)) = First_Index (Get_Routes (This'Old))
           and then Last_Index (Get_Routes (This)) = Last_Index (Get_Routes (This'Old))
           and then (for all I in First_Index (Get_Routes (This'Old)) .. Last_Index (Get_Routes (This'Old))
                     => Element (Get_Routes (This), I) = Element (Get_Routes (This'Old), I)));

   procedure Add_Route
     (This : in out My_RouteResponse;
      Route : My_RoutePlanResponse) with
     Global => null,
     Post => Last_Element (Get_Routes (This)) = Route
     and  (First_Index (Get_Routes (This)) = First_Index (Get_Routes (This'Old))
           and then Last_Index (Get_Routes (This)) = Last_Index (Get_Routes (This'Old))  + 1
           and then (for all I  in First_Index (Get_Routes (This'Old)) .. Last_Index (Get_Routes (This'Old))
                     => Element (Get_Routes (This), I) = Element (Get_Routes (This'Old), I)))
     and Get_ResponseID (This) = Get_ResponseID (This'Old);

   function Unwrap (This : My_RouteResponse) return RouteResponse;

   function Wrap (This : RouteResponse) return My_RouteResponse;

private
   pragma SPARK_Mode (Off);
   type My_RouteResponse is record
      Content : RouteResponse;
   end record;

   function Get_ResponseID
     (This : My_RouteResponse) return Int64 is
     (This.Content.getResponseID);

   overriding function "=" (X, Y : My_RouteResponse) return Boolean is
     (X.Content = Y.Content);

   function Unwrap (This : My_RouteResponse) return RouteResponse is
     (This.Content);

   function Wrap (This : RouteResponse) return My_RouteResponse is
     (Content => This);

end uxas.messages.route.RouteResponse.SPARK_Boundary;
