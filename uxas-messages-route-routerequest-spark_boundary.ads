

with Common_Formal_Containers; use Common_Formal_Containers;

with UxAS.Messages.Route.RouteConstraints.Spark_Boundary.Vects; use UxAS.Messages.Route.RouteConstraints.Spark_Boundary.Vects;
with Uxas.Messages.Route.RouteConstraints; 
with UxAS.Messages.Route.RouteConstraints.Spark_Boundary; use UxAS.Messages.Route.RouteConstraints.Spark_Boundary;

package  UxAS.Messages.Route.RouteRequest.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);
   


   --  This package introduces a wrapper around RouteRequest.
   --  RouteRequest is a private type, so it can be used in SPARK.
   --  This wrapper is only used to introduce contracts on the type and
   --  its accessors.
  
   
   use all type Int64_Vect;
   
   use all type Vect_My_RouteConstraints;
  
   
   type My_RouteRequest is private;

   
   function Get_RequestID 
     (This : My_RouteRequest) return Int64
     with Global => null;
   
   
   function Get_AssociatedTaskID
     (This : My_RouteRequest) return Int64
     with Global => null;
   
   function Get_VehicleID
     (Request : My_RouteRequest) return Int64_Vect
     with Global => null;
   
   function Get_OperatingRegion
     (This : My_RouteRequest) return Int64
     with Global => null;
   
   function Get_RouteRequests
     (Request : My_RouteRequest) return Vect_My_RouteConstraints
     with Global => null;
   
   procedure Add_VehiclesID
     (This : in out My_RouteRequest;
      VehiclesID : Int64) with
     Global => null,
     Post => Last_Element(Get_VehicleID(This)) = VehiclesID
     and (First_Index(Get_VehicleID (This)) = First_Index(Get_VehicleID (This'Old) )
          and then Last_Index(Get_VehicleID (This)) = Last_Index(Get_VehicleID (This'Old) ) + 1
          and then ( for all I in First_Index(Get_VehicleID (This'Old)) ..  Last_Index(Get_VehicleID (This'Old) )
                    => (Element(Get_VehicleID (This), I) = Element(Get_VehicleID (This'Old), I) )))
     and Get_RequestID(This) =  Get_RequestID(This'Old) 
     and Get_AssociatedTaskID (This) =
     Get_AssociatedTaskID (This)'Old 
     and Get_OperatingRegion (This)
     = Get_OperatingRegion (This)'Old
     and Get_RouteRequests (This)
     = Get_RouteRequests (This)'Old
     
     and (First_Index(Get_RouteRequests (This)) = First_Index(Get_RouteRequests (This'Old) )
          and then Last_Index(Get_RouteRequests (This)) = Last_Index(Get_RouteRequests (This'Old) )
          and then ( for all I in First_Index(Get_RouteRequests (This)) ..  Last_Index(Get_RouteRequests (This'Old) )
                    => (Element(Get_RouteRequests (This), I) = Element(Get_RouteRequests (This'Old), I) )));
   
     
   procedure Add_RouteConstraints 
     (This : in out My_RouteRequest;
      Route_Constraints : in My_RouteConstraints)
     with Global => null,
     Post => 
       (Length (Get_RouteRequests (This'Old) )
        = Length (Get_RouteRequests (This)) + 1)
     and Last_Element(Get_RouteRequests (This)) = Route_Constraints
     and (for all L in Natural
          => (if ( L /= Last_Index(Get_RouteRequests (This))) then
                Element ( Get_RouteRequests(This), L) =
                  Element ( Get_RouteRequests(This'Old),  L )))
     
     and Get_AssociatedTaskID (This) =
     Get_AssociatedTaskID (This)'Old 
     and Get_OperatingRegion (This)
     = Get_OperatingRegion (This)'Old
     and (First_Index(Get_VehicleID (This)) = First_Index(Get_VehicleID (This'Old) )
          and then Last_Index(Get_VehicleID (This)) = Last_Index(Get_VehicleID (This'Old) )
          and then ( for all I in First_Index(Get_VehicleID (This'Old)) ..  Last_Index(Get_VehicleID (This'Old) )
                    => (Element(Get_VehicleID (This), I) = Element(Get_VehicleID (This'Old), I) ))) ;
     
     
   function Same_Requests (X, Y : My_RouteRequest) return Boolean is
     (Get_RequestID (X) = Get_RequestID (Y)
      and Get_AssociatedTaskID (X) =
          Get_AssociatedTaskID (Y)
      and Get_OperatingRegion (X) =
          Get_OperatingRegion (Y)
      and Get_RouteRequests (X) = 
          Get_RouteRequests (Y)
      and (First_Index(Get_RouteRequests (X)) = First_Index(Get_RouteRequests (Y) )
           and then Last_Index(Get_RouteRequests (X)) = Last_Index(Get_RouteRequests (Y) )
           and then ( for all I in First_Index(Get_RouteRequests (X)) ..  Last_Index(Get_RouteRequests (X) )
                     => (Element(Get_RouteRequests (X), I) = Element(Get_RouteRequests (Y), I) )))
      and (First_Index(Get_VehicleID (X)) = First_Index(Get_VehicleID (Y) )
           and then Last_Index(Get_VehicleID (X)) = Last_Index(Get_VehicleID (Y) )
           and then ( for all I in First_Index(Get_VehicleID (X)) ..  Last_Index(Get_VehicleID (X) )
                     => (Element(Get_VehicleID (X), I) = Element(Get_VehicleID (Y), I) ))));
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
     and Get_OperatingRegion (This)
     = Get_OperatingRegion (This)'Old
     and Get_RouteRequests (This)
     = Get_RouteRequests (This)'Old
     and (First_Index(Get_VehicleID (This)) = First_Index(Get_VehicleID (This'Old) )
          and then Last_Index(Get_VehicleID (This)) = Last_Index(Get_VehicleID (This'Old) )
          and then ( for all I in First_Index(Get_VehicleID (This'Old)) ..  Last_Index(Get_VehicleID (This'Old) )
                    => (Element(Get_VehicleID (This), I) = Element(Get_VehicleID (This'Old), I) )))
     and (First_Index(Get_RouteRequests (This)) = First_Index(Get_RouteRequests (This'Old) )
          and then Last_Index(Get_RouteRequests (This)) = Last_Index(Get_RouteRequests (This'Old) )
          and then ( for all I in First_Index(Get_RouteRequests (This)) ..  Last_Index(Get_RouteRequests (This'Old) )
                    => (Element(Get_RouteRequests (This), I) = Element(Get_RouteRequests (This'Old), I) )));
   
   procedure Set_AssociatedTaskID 
     (This : in out My_RouteRequest;
      AssociatedTaskID : Int64)
     with Global => null,
     Post => Get_AssociatedTaskID(This) = AssociatedTaskID 
     and Get_RequestID(This) 
     = Get_RequestID(This)'Old 
     and Get_OperatingRegion (This)
     = Get_OperatingRegion (This)'Old
     and Get_RouteRequests (This)
     = Get_RouteRequests (This)'Old
     and (First_Index(Get_VehicleID (This)) = First_Index(Get_VehicleID (This'Old) )
          and then Last_Index(Get_VehicleID (This)) = Last_Index(Get_VehicleID (This'Old) )
          and then ( for all I in First_Index(Get_VehicleID (This'Old)) ..  Last_Index(Get_VehicleID (This'Old) )
                    => (Element(Get_VehicleID (This), I) = Element(Get_VehicleID (This'Old), I) )))
     and (First_Index(Get_RouteRequests (This)) = First_Index(Get_RouteRequests (This'Old) )
          and then Last_Index(Get_RouteRequests (This)) = Last_Index(Get_RouteRequests (This'Old) )
          and then ( for all I in First_Index(Get_RouteRequests (This)) ..  Last_Index(Get_RouteRequests (This'Old) )
                    => (Element(Get_RouteRequests (This), I) = Element(Get_RouteRequests (This'Old), I) )));
   
   procedure Set_OperatingRegion
     (This : in out My_RouteRequest;
      OperatingRegion : Int64)
     with Global => null,
     Post => Get_OperatingRegion(This) = OperatingRegion 
     and Get_RequestID(This) 
     = Get_RequestID(This)'Old 
     and Get_AssociatedTaskID (This) 
     = Get_AssociatedTaskID (This)'Old 
     and Get_RouteRequests (This)
     = Get_RouteRequests (This)'Old
     and (First_Index(Get_VehicleID (This)) = First_Index(Get_VehicleID (This'Old) )
          and then Last_Index(Get_VehicleID (This)) = Last_Index(Get_VehicleID (This'Old) )
          and then ( for all I in First_Index(Get_VehicleID (This'Old)) ..  Last_Index(Get_VehicleID (This'Old) )
                    => (Element(Get_VehicleID (This), I) = Element(Get_VehicleID (This'Old), I) )))
     and (First_Index(Get_RouteRequests (This)) = First_Index(Get_RouteRequests (This'Old) )
          and then Last_Index(Get_RouteRequests (This)) = Last_Index(Get_RouteRequests (This'Old) )
          and then ( for all I in First_Index(Get_RouteRequests (This)) ..  Last_Index(Get_RouteRequests (This'Old) )
                    => (Element(Get_RouteRequests (This), I) = Element(Get_RouteRequests (This'Old), I) )));
   
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
