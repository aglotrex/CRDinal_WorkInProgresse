package body Afrl.Cmasi.Location3D.Spark_Boundary with SPARK_Mode => Off is

   
   procedure Set_Latitude
     (This : in out  My_Location3D_Any;
      Latitude : in Real64)
   is 
   begin
      This.Content.SetLatitude(Latitude);
   end Set_Latitude;
   
   
   procedure Set_Longitude
     (This : in out My_Location3D_Any;
      Longitude : in Real64)
   is 
   begin
      This.Content.SetLongitude(Longitude);
   end Set_Longitude;
   
   procedure Set_Altitude
     (This : in out My_Location3D_Any; 
      Altitude : in Real32)
   is 
   begin
      This.Content.SetAltitude(Altitude);
   end Set_Altitude;
   
   
   procedure Set_AltitudeType
     (This : in out My_Location3D_Any; 
      AltitudeType : in AltitudeTypeEnum)
   is 
   begin
      This.Content.SetAltitudeType(AltitudeType);
   end Set_AltitudeType;
   
end Afrl.Cmasi.Location3D.Spark_Boundary;
