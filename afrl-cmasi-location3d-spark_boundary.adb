package body Afrl.Cmasi.Location3D.Spark_Boundary with SPARK_Mode => Off is

   procedure Set_Latitude
     (This : in out  My_Location3D_Any;
      Latitude : in Real64)
   is
   begin
      This.Content.setLatitude (Latitude);
   end Set_Latitude;


   procedure Set_Longitude
     (This : in out My_Location3D_Any;
      Longitude : in Real64)
   is
   begin
      This.Content.setLongitude (Longitude);
   end Set_Longitude;

   procedure Set_Altitude
     (This : in out My_Location3D_Any;
      Altitude : in Real32)
   is
   begin
      This.Content.setAltitude (Altitude);
   end Set_Altitude;


   procedure Set_AltitudeType
     (This : in out My_Location3D_Any;
      AltitudeType : in AltitudeTypeEnum)
   is
   begin
      This.Content.setAltitudeType (AltitudeType);
   end Set_AltitudeType;

end Afrl.Cmasi.Location3D.Spark_Boundary;
