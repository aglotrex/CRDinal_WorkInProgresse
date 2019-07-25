with Afrl.Cmasi.Location3D; use Afrl.Cmasi.Location3D;


package Afrl.Cmasi.Location3D.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, Spark_Boundary);


   Dividend_Max : constant := 10_000_000_000.0;
   
   type My_Location3D_Any is private with 
     Default_Initial_Condition => True;

   function Get_Latitude
     (This : My_Location3D_Any) return Real64 with
     Global => null,
     Post => Get_Latitude'Result in -Dividend_Max .. Dividend_Max;

   function Get_Longitude
     (This : My_Location3D_Any) return Real64 with
     Global => null,
     Post => Get_Longitude'Result in -Dividend_Max .. Dividend_Max;

   function Get_Altitude
     (This : My_Location3D_Any) return Real32 with
     Global => null;

   function Get_AltitudeType
     (This : My_Location3D_Any) return AltitudeTypeEnum with
     Global => null;

   function Same_Requests (X, Y : My_Location3D_Any) return Boolean is
     (Get_Latitude (X)         = Get_Latitude (Y)
      and Get_Longitude (X)    = Get_Longitude (Y)
      and Get_AltitudeType (X) = Get_AltitudeType (Y)
      and Get_Altitude (X)     = Get_Altitude (Y))
       with Global => null;

   overriding function "=" (X, Y : My_Location3D_Any) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));

   procedure Set_Latitude
     (This : in out My_Location3D_Any;
      Latitude : in Real64)
     with Global => null,
     Pre => Latitude in -Dividend_Max .. Dividend_Max,
     Post => Get_Latitude (This) = Latitude
     and Get_Longitude (This) =
     Get_Longitude (This)'Old
     and Get_AltitudeType (This) =
     Get_AltitudeType (This)'Old
     and Get_Altitude (This)    =
     Get_Altitude (This)'Old;

   procedure Set_Longitude
     (This : in out My_Location3D_Any;
      Longitude : in Real64)
     with Global => null,
     Pre => Longitude in -Dividend_Max .. Dividend_Max,
     Post => Get_Longitude (This) = Longitude
     and Get_Latitude (This) =
     Get_Latitude (This)'Old
     and Get_AltitudeType (This) =
     Get_AltitudeType (This)'Old
     and Get_Altitude (This)    =
     Get_Altitude (This)'Old;

   procedure Set_Altitude
     (This : in out My_Location3D_Any;
      Altitude : Real32)
     with Global => null,
     Post => Get_Altitude (This) = Altitude
     and Get_Latitude (This) = 
     Get_Latitude (This)'Old
     and Get_Longitude (This) =
     Get_Longitude (This)'Old
     and Get_AltitudeType (This)    =
     Get_AltitudeType (This)'Old;

   procedure Set_AltitudeType
     (This : in out My_Location3D_Any;
      AltitudeType : in AltitudeTypeEnum)
     with Global => null,
     Post => Get_AltitudeType (This) = AltitudeType
     and Get_Latitude (This)   = 
     Get_Latitude (This)'Old
     and Get_Longitude (This) =
     Get_Longitude (This)'Old
     and Get_Altitude (This)  =
     Get_Altitude (This)'Old;

   function Wrap (This : Location3D_Any) return My_Location3D_Any with
     Inline,
     Global => null,
     SPARK_Mode => Off;
   function Unwrap (This : My_Location3D_Any) return Location3D_Any with
     Inline,
     Global => null,
     SPARK_Mode => Off;

private
   pragma SPARK_Mode (Off);

   type My_Location3D_Any is record
      Content : Location3D_Any;
   end record;



   function Get_Latitude
     (This : My_Location3D_Any) return Real64 is
     (This.Content.GetLatitude);

   function Get_Longitude
     (This : My_Location3D_Any) return Real64 is
     (This.Content.GetLongitude);

   function Get_Altitude
     (This : My_Location3D_Any) return Real32 is
     (This.Content.GetAltitude);

   function Get_AltitudeType
     (This : My_Location3D_Any) return AltitudeTypeEnum is
     (This.Content.GetAltitudeType);


   function Wrap (This : Location3D_Any) return My_Location3D_Any is
     (Content => This)
     with SPARK_Mode => Off;
   function Unwrap (This : My_Location3D_Any) return Location3D_Any is
     (This.Content)
     with SPARK_Mode => Off;
   overriding function "=" (X, Y : My_Location3D_Any) return Boolean is
     (Unwrap (X) = Unwrap (Y));


end Afrl.Cmasi.Location3D.SPARK_Boundary;
