with Ada.Containers; use Ada.Containers;
with Ada.Containers.Vectors;

with Common_Formal_Containers; use Common_Formal_Containers;
with Uxas.Messages.Route.RouteConstraints; use Uxas.Messages.Route.RouteConstraints; 
with UxAS.Messages.Route.RouteConstraints.Spark_Boundary; use UxAS.Messages.Route.RouteConstraints.Spark_Boundary;
 

package  UxAS.Messages.Route.RouteRequest.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   --  This package introduces a wrapper around RouteRequest.
   --  RouteRequest is a private type, so it can be used in SPARK.
   --  This wrapper is only used to introduce contracts on the type and
   --  its accessors.

   use all type Int64_Vect;
   
  
   package Vect_My_RouteConstraints is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => My_RouteConstraints);
   use Vect_My_RouteConstraints;
  
   
   type Vect_My_RouteConstraints_Acc is access all Vect_My_RouteConstraints.Vector;

   
   type My_RouteRequest is private;

   
   function Get_RequestID 
     (This : My_RouteRequest) return Int64
     with Global => null;
   
   
   function Get_AssociatedTaskID
     (This : My_RouteRequest) return Int64
     with Global => null;
   
   function Get_Vehicle_ID
     (Request : My_RouteRequest) return Int64_Vect
     with Global => null;
   
   function Get_OperatingRegion
     (This : My_RouteRequest) return Int64
     with Global => null;
   
   function Get_RouteRequests
     (Request : My_RouteRequest) return Vect_My_RouteConstraints_Acc
     with Global => null;
   
   
   procedure Add_RouteConstraints 
     (This : in out My_RouteRequest;
      Route_Constraints : in My_RouteConstraints)
     with Global => null,
     Post => 
       Get_RouteRequests (This'Old).Length =  Get_RouteRequests (This).Length+1
     and Get_RouteRequests (This).Last_Element = Route_Constraints
     and (for all L in Natural
          => (if ( L /= Get_RouteRequests (This).Last_Index) then
                  Get_RouteRequests(This).Element(Index => L ) =
                Get_RouteRequests(This'Old).Element(Index => L )))
     
     and Get_AssociatedTaskID (This) =
     Get_AssociatedTaskID (This)'Old 
     and Get_Vehicle_ID (This) 
     = Get_Vehicle_ID (This)'Old
     and Get_OperatingRegion (This)
     = Get_OperatingRegion (This)'Old;
     
     
   function Same_Requests (X, Y : My_RouteRequest) return Boolean is
     (Get_RequestID (X) = Get_RequestID (Y)
      and Get_AssociatedTaskID (X) =
          Get_AssociatedTaskID (Y)
      and Get_Vehicle_ID (X) =
          Get_Vehicle_ID (Y)
      and Get_OperatingRegion (X) =
          Get_OperatingRegion (Y)
      and Get_RouteRequests (X) = 
          Get_RouteRequests (Y)
      and (for all L in Integer
           => (Get_RouteRequests (X).Element(L) = Get_RouteRequests (Y).Element(L))));
   --  pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
     
     
   overriding function "=" (X, Y : My_RouteRequest) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
   
   
   procedure Set_RequestID 
     (This : in out My_RouteRequest;
      RequestID : Int64)
     with Global => null,
     Post => Get_RequestID(This) = RequestID 
     and Get_AssociatedTaskID (This) =
     Get_AssociatedTaskID (This)'Old 
     and Get_Vehicle_ID (This) 
     = Get_Vehicle_ID (This)'Old
     and Get_OperatingRegion (This)
     = Get_OperatingRegion (This)'Old
     and Get_RouteRequests (This)
     = Get_RouteRequests (This)'Old;
   
   procedure Set_AssociatedTaskID 
     (This : in out My_RouteRequest;
      AssociatedTaskID : Int64)
     with Global => null,
     Post => Get_AssociatedTaskID(This) = AssociatedTaskID 
     and Get_RequestID(This) 
     = Get_RequestID(This)'Old 
     and Get_Vehicle_ID (This) 
     = Get_Vehicle_ID (This)'Old
     and Get_OperatingRegion (This)
     = Get_OperatingRegion (This)'Old
     and Get_RouteRequests (This)
     = Get_RouteRequests (This)'Old;
   
   procedure Set_OperatingRegion
     (This : in out My_RouteRequest;
      OperatingRegion : Int64)
     with Global => null,
     Post => Get_OperatingRegion(This) = OperatingRegion 
     and Get_RequestID(This) 
     = Get_RequestID(This)'Old 
     and Get_AssociatedTaskID (This) 
     = Get_AssociatedTaskID (This)'Old 
     and Get_Vehicle_ID (This) 
     = Get_Vehicle_ID (This)'Old
     and Get_RouteRequests (This)
     = Get_RouteRequests (This)'Old;
   
   function Unwrap (This : My_RouteRequest) return RouteRequest;
   
   function Wrap (This : RouteRequest) return My_RouteRequest;
   
private
   pragma SPARK_Mode(Off);
   type My_RouteRequest is record
      Content : RouteRequest;
   end record;
   
   overriding function "=" (X, Y : My_RouteRequest) return Boolean is
     (X.Content = Y.Content);

   function Get_RequestID (This : My_RouteRequest) return Int64 is
     (This.Content.GetRequestID);
   
   function Get_AssociatedTaskID (This : My_RouteRequest) return Int64 is
     (This.Content.GetRequestID);
   
   function Get_OperatingRegion (This : My_RouteRequest) return Int64 is 
     (This.Content.GetOperatingRegion);

   function Unwrap (This : My_RouteRequest) return RouteRequest is
     (This.Content);

   function Wrap (This : RouteRequest) return My_RouteRequest is
     (Content => This);
   
   
end UxAS.Messages.Route.RouteRequest.SPARK_Boundary;
