
package body UxAS.Messages.Route.RouteConstraints.SPARK_Boundary with SPARK_Mode => Off is

   -------------------
   --  Set_RouteID  --
   -------------------

   procedure Set_RouteID
     (This : in out My_RouteConstraints;
      RouteID : in Int64)
   is 
   begin
      This.Content.setRouteID (RouteID);
   end Set_RouteID;

   -------------------------
   --  Set_StartLocation  --
   -------------------------


   procedure Set_StartLocation
     (This : in out My_RouteConstraints;
      StartLocation : in My_Location3D_Any)
   is
   begin
      This.Content.setStartLocation (Unwrap (StartLocation));
   end Set_StartLocation;

   ------------------------
   --  Set_StartHeading  --
   ------------------------

   procedure Set_StartHeading
     (This : in out My_RouteConstraints;
      StartHeading : in Real32)
   is
   begin
      This.Content.setStartHeading (StartHeading);
   end Set_StartHeading;

   ---------------------------
   --  Set_UseStartHeading  --
   ---------------------------

   procedure Set_UseStartHeading
     (This : in out My_RouteConstraints;
      UseStartHeading : in Boolean)
   is
   begin
      This.Content.setUseStartHeading (UseStartHeading);
   end Set_UseStartHeading;

   -----------------------
   --  Set_EndLocation  --
   -----------------------
   
   procedure Set_EndLocation
     (This : in out My_RouteConstraints;
      EndLocation : in My_Location3D_Any)
   is
   begin
      This.Content.setEndLocation (Unwrap (EndLocation));
   end Set_EndLocation;

   ----------------------
   --  Set_EndHeading  --
   ----------------------

   procedure Set_EndHeading
     (This : in out My_RouteConstraints;
      EndHeading : in Real32)
   is
   begin
      This.Content.setEndHeading (EndHeading);
   end Set_EndHeading;

   -------------------------
   --  Set_UseEndHeading  --
   -------------------------

   procedure Set_UseEndHeading
     (This : in out My_RouteConstraints;
      UseEndHeading : in Boolean)
   is
   begin
      This.Content.setUseEndHeading (UseEndHeading);
   end Set_UseEndHeading;



end UxAS.Messages.Route.RouteConstraints.SPARK_Boundary;
