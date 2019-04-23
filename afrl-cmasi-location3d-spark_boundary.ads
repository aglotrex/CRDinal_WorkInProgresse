with Afrl.Cmasi.Location3D; use Afrl.Cmasi.Location3D;


package Afrl.Cmasi.Location3D.Spark_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   --  This package introduces a wrapper around UniqueAutomationRequest.
   --  UniqueAutomationRequest is a private type, so it can be used in SPARK.
   --  This wrapper is only used to introduce contracts on the type and
   --  its accessors.

   
   type My_Location3D is private;
   
   function Get_Latitude
     (This : My_Location3D) return Real64;
   
   function Get_Longitude
     (This : My_Location3D) return Real64;
   
   function Same_Requests (X, Y : My_Location3D) return Boolean is
     (Get_Latitude (X) = 
          Get_Latitude (Y)
      and Get_Longitude (X) =
          Get_Longitude (Y))
   with Global => null;
   
   overriding function "=" (X, Y : My_Location3D) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
   
   procedure Set_Latitude
     (This : in out My_Location3D;
      Latitude : in Real64)
     with Global => null,
     Post => Get_Latitude(This) = Latitude
     and Get_Longitude (This) =
     Get_Longitude (This)'Old;
   
   procedure Set_Longitude
     (This : in out My_Location3D;
      Longitude : in Real64)
     with Global => null,
     Post => Get_Longitude(This) = Longitude
     and Get_Latitude (This) =
     Get_Latitude (This)'Old;
   
      
   function Unwrap (This : My_Location3D) return Location3D;
   
   function Wrap (This : Location3D) return My_Location3D;
   
private
   pragma SPARK_Mode(Off);
   
   type My_Location3D is record
      Content : Location3D;
   end record;
   
   overriding function "=" (X, Y : My_Location3D) return Boolean is
     (X.Content = Y.Content);
   
   function Get_Latitude
     (This : My_Location3D) return Real64 is 
     (This.Content.GetLatitude);
   
   function Get_Longitude
     (This : My_Location3D) return Real64 is 
     (This.Content.GetLongitude);
   
   function Unwrap (This : My_Location3D) return Location3D is
     (This.Content);

   function Wrap (This : Location3D) return My_Location3D is
     (Content => This);
   

end Afrl.Cmasi.Location3D.Spark_Boundary;
