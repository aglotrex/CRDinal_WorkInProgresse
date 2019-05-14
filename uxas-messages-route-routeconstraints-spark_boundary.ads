with uxas.messages.route.RouteConstraints; use uxas.messages.route.RouteConstraints;
with Afrl.Cmasi.Location3D.SPARK_Boundary; use Afrl.Cmasi.Location3D.SPARK_Boundary;


package UxAS.Messages.Route.RouteConstraints.SPARK_Boundary with SPARK_Mode is


   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);


   type My_RouteConstraints is private with 
   Default_Initial_Condition => True;

   function Get_RouteID
     (This : My_RouteConstraints) return Int64
     with Global => null;


   function Get_StartLocation
     (This : My_RouteConstraints) return My_Location3D_Any
     with Global => null;

   function Get_StartHeading
     (This : My_RouteConstraints) return Real32
     with Global => null;

   function Get_UseStartHeading
     (This : My_RouteConstraints) return Boolean
     with Global => null;


   function Get_EndLocation
     (This : My_RouteConstraints) return My_Location3D_Any
     with Global => null;

   function Get_EndHeading
     (This : My_RouteConstraints) return Real32
     with Global => null;

   function Get_UseEndHeading
     (This : My_RouteConstraints) return Boolean
     with Global => null;

   function Same_Requests (X, Y : My_RouteConstraints) return Boolean is
     (Get_RouteID (X) = Get_RouteID (Y)
      and Get_StartLocation (X)   = Get_StartLocation (Y)
      and Get_StartHeading (X)    = Get_StartHeading (Y)
      and Get_UseStartHeading (X) = Get_UseStartHeading (Y)
      and Get_EndLocation (X)     = Get_EndLocation (Y)
      and Get_EndHeading (X)      = Get_EndHeading (Y)
      and Get_UseEndHeading (X)   = Get_UseEndHeading (Y));
   --  pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);

   overriding function "=" (X, Y : My_RouteConstraints) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));

   procedure Set_RouteID
     (This : in out My_RouteConstraints;
      RouteID : in Int64)
     with Global => null,
     Post => Get_RouteID (This) = RouteID
     and Get_StartLocation (This) =
     Get_StartLocation (This)'Old
     and Get_StartHeading (This) =
     Get_StartHeading (This)'Old
     and Get_UseStartHeading (This) =
     Get_UseStartHeading (This)'Old
     and Get_EndLocation (This) =
     Get_EndLocation (This)'Old
     and Get_EndHeading (This) =
     Get_EndHeading (This)'Old
     and  Get_UseEndHeading (This) =
     Get_UseEndHeading (This)'Old;


   procedure Set_StartLocation
     (This : in out My_RouteConstraints;
      StartLocation : in My_Location3D_Any)
     with Global => null,
     Post =>  Get_StartLocation (This) = StartLocation
     and Get_RouteID (This) =
     Get_RouteID (This)'Old
     and Get_StartHeading (This) =
     Get_StartHeading (This)'Old
     and Get_UseStartHeading (This) =
     Get_UseStartHeading (This)'Old
     and Get_EndLocation (This) =
     Get_EndLocation (This)'Old
     and Get_EndHeading (This) =
     Get_EndHeading (This)'Old
     and  Get_UseEndHeading (This) =
     Get_UseEndHeading (This)'Old;

   procedure Set_StartHeading
     (This : in out My_RouteConstraints;
      StartHeading : in Real32)
     with Global => null,
     Post => Get_StartHeading (This) = StartHeading
     and Get_RouteID (This) =
     Get_RouteID (This)'Old
     and Get_StartLocation (This) =
     Get_StartLocation (This)'Old
     and Get_UseStartHeading (This) = 
     Get_UseStartHeading (This)'Old
     and Get_EndLocation (This) =
     Get_EndLocation (This)'Old
     and Get_EndHeading (This) =
     Get_EndHeading (This)'Old
     and  Get_UseEndHeading (This) = 
     Get_UseEndHeading (This)'Old;
   
   procedure Set_UseStartHeading
     (This : in out My_RouteConstraints ;
      UseStartHeading : in Boolean)
     with Global => null,
     Post => Get_UseStartHeading (This) = UseStartHeading
     and Get_RouteID (This) =
     Get_RouteID (This)'Old
     and Get_StartLocation (This) =
     Get_StartLocation (This)'Old
     and Get_StartHeading (This) =
     Get_StartHeading (This)'Old
     and Get_EndLocation (This) =
     Get_EndLocation (This)'Old
     and Get_EndHeading (This) =
     Get_EndHeading (This)'Old
     and  Get_UseEndHeading (This) =
     Get_UseEndHeading (This)'Old;


   procedure Set_EndLocation
     (This : in out My_RouteConstraints;
      EndLocation : in My_Location3D_Any)
     with Global => null,
     Post => Get_EndLocation (This) = EndLocation
     and Get_RouteID (This) =
     Get_RouteID (This)'Old
     and Get_StartLocation (This) =
     Get_StartLocation (This)'Old
     and Get_StartHeading (This) =
     Get_StartHeading (This)'Old
     and Get_UseStartHeading (This) =
     Get_UseStartHeading (This)'Old
     and Get_EndHeading (This) =
     Get_EndHeading (This)'Old
     and  Get_UseEndHeading (This) = 
     Get_UseEndHeading (This)'Old;
   
   procedure Set_EndHeading
     (This : in out My_RouteConstraints;
      EndHeading : in Real32)
     with Global => null,
     Post =>  Get_EndHeading (This) = EndHeading
     and Get_RouteID (This) =
     Get_RouteID (This)'Old
     and Get_StartLocation (This) =
     Get_StartLocation (This)'Old
     and Get_StartHeading (This) =
     Get_StartHeading (This)'Old
     and Get_UseStartHeading (This) =
     Get_UseStartHeading (This)'Old
     and Get_EndLocation (This) =
     Get_EndLocation (This)'Old
     and  Get_UseEndHeading (This) =
     Get_UseEndHeading (This)'Old;

   procedure Set_UseEndHeading
     (This : in out My_RouteConstraints;
      UseEndHeading : in Boolean)
     with Global => null,
     Post => Get_UseEndHeading (This) = UseEndHeading
     and Get_RouteID (This) =
     Get_RouteID (This)'Old
     and Get_StartLocation (This) =
     Get_StartLocation (This)'Old
     and Get_StartHeading (This) =
     Get_StartHeading (This)'Old
     and Get_UseStartHeading (This) =
     Get_UseStartHeading (This)'Old
     and Get_EndLocation (This) =
     Get_EndLocation (This)'Old
     and Get_EndHeading (This) =
     Get_EndHeading (This)'Old;

   function Unwrap (This : My_RouteConstraints) return RouteConstraints;

   function Wrap (This : RouteConstraints) return My_RouteConstraints;
private
   pragma SPARK_Mode (Off);
   type My_RouteConstraints is record
      Content : RouteConstraints;
   end record;




   overriding function "=" (X, Y : My_RouteConstraints) return Boolean is
     (X.Content = Y.Content);

   function Get_RouteID
     (This : My_RouteConstraints) return Int64 is
     (This.Content.getRouteID);


   function Get_StartLocation
     (This : My_RouteConstraints) return My_Location3D_Any is
     (Wrap (This => This.Content.getStartLocation));

   function Get_StartHeading
     (This : My_RouteConstraints) return Real32 is
     (This.Content.getStartHeading);

   function Get_UseStartHeading
     (This : My_RouteConstraints) return Boolean is
     (This.Content.getUseStartHeading);


   function Get_EndLocation
     (This : My_RouteConstraints) return My_Location3D_Any is
     (Wrap (This =>  This.Content.getEndLocation));

   function Get_EndHeading
     (This : My_RouteConstraints) return Real32 is
     (This.Content.getEndHeading);

   function Get_UseEndHeading
     (This : My_RouteConstraints) return Boolean is
     (This.Content.getUseEndHeading);

   function Unwrap (This : My_RouteConstraints) return RouteConstraints is
     (This.Content);

   function Wrap (This : RouteConstraints) return My_RouteConstraints is
     (Content => This);

end UxAS.Messages.Route.RouteConstraints.SPARK_Boundary ;
