package body Afrl.Cmasi.Location3D.Spark_Boundary with SPARK_Mode => Off is

   
procedure Set_Latitude
     (This : in out  My_Location3D;
      Latitude : in Real64)
   is 
   begin
      This.Content.SetLatitude(Latitude);
   end Set_Latitude;
   
   
   procedure Set_Longitude
     (This : in Out My_Location3D;
      Longitude : in Real64)
     is 
   begin
      This.Content.setLongitude(Longitude);
   end Set_Longitude;
   
end Afrl.Cmasi.Location3D.Spark_Boundary;
