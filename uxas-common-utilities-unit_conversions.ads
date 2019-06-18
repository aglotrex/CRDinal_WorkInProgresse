with Convert;                                use Convert;

package Uxas.Common.Utilities.Unit_Conversions  with SPARK_Mode is
   
   
    --  type Unit_Conversions_Ref is  access all Unit_Conversions'Class;

   procedure Initialize (Latitude_Init_RAD  : in RAD_Latitude;
                         Longitude_Init_RAD : in RAD_Angle);
   procedure Re_Initialize (Latitude_Init_RAD  : in RAD_Latitude;
                            Longitude_Init_RAD : in RAD_Angle);

   --  ////////////////////////////////////////////////////////////////////////////
   --  ///////    FROM LAT/LONG TO NORTH/EAST

   procedure Convert_Lat_Long_RAD_To_North_East_M
     (Latitude_RAD  : in RAD_Latitude;
      Longitude_RAD : in RAD_Angle;
      North_M      : out Earth_Coordonate_M;
      East_M       : out Earth_Coordonate_M);
   procedure Convert_Lat_Long_RAD_To_North_East_FT
     (Latitude_RAD  : in RAD_Latitude;
      Longitude_RAD : in RAD_Angle;
      North_FT     : out Earth_Coordonate_FT;
      East_FT      : out Earth_Coordonate_FT);
   procedure Convert_Lat_Long_DEG_To_North_East_M
     (Latitude_DEG  : in DEG_Latitude;
      Longitude_DEG : in DEG_Angle;
      North_M      : out Earth_Coordonate_M;
      East_M       : out Earth_Coordonate_M);
   procedure Convert_Lat_Long_DEG_To_North_East_FT
     (Latitude_DEG  : in DEG_Latitude;
      Longitude_DEG : in DEG_Angle;
      North_FT     : out Earth_Coordonate_FT;
      East_FT      : out Earth_Coordonate_FT);


   --  ////////////////////////////////////////////////////////////////////////////
   --  ///////     FROM NORTH/EAST TO LAT/LONG

   procedure Convert_North_East_M_To_Lat_Long_RAD
     (North_M       : in  Earth_Coordonate_M;
      East_M        : in  Earth_Coordonate_M;
      Latitude_RAD  : out RAD_Latitude;
      Longitude_RAD : out RAD_Angle) with
     Global => (Radius_Meridional_M, Latitude_Initial_RAD
                , Radius_Small_Circle_Latitude_M,Longitude_Initial_RAD),
     Pre => (Radius_Meridional_M > 0.0)
     and    (Radius_Small_Circle_Latitude_M > 0.0);


   procedure Convert_North_East_M_To_Lat_Long_DEG
     (North_M       : in Earth_Coordonate_M;
      East_M        : in Earth_Coordonate_M;
      Latitude_DEG  : out DEG_Latitude;
      Longitude_DEG : out DEG_Angle) with 
     Global => (Radius_Meridional_M, Latitude_Initial_RAD
                , Radius_Small_Circle_Latitude_M,Longitude_Initial_RAD),
     Pre => Radius_Meridional_M > 0.0
     and  Radius_Small_Circle_Latitude_M > 0.0 ;

   procedure Convert_North_East_FT_To_Lat_Long_DEG
     (North_FT      : in Earth_Coordonate_FT;
      East_FT       : in Earth_Coordonate_FT;
      Latitude_DEG  : out DEG_Latitude;
      Longitude_DEG : out DEG_Angle) with 
     Global => (Radius_Meridional_M, Latitude_Initial_RAD
                , Radius_Small_Circle_Latitude_M,Longitude_Initial_RAD),
     Pre => Radius_Meridional_M > 0.0
     and  Radius_Small_Circle_Latitude_M > 0.0;

   -- void ConvertNorthEast_ftToLatLong_deg(const Long_float& dNorth_ft, const Long_float& dEast_ft, Long_float& dLatitude_deg, Long_float& dLongitude_deg); 
   procedure Convert_North_East_FT_To_Lat_Long_RAD
     (North_FT      : in  Earth_Coordonate_FT;
      East_FT       : in  Earth_Coordonate_FT;
      Latitude_RAD  : out RAD_Latitude;
      Longitude_RAD : out RAD_Angle) with
     Global => (Radius_Meridional_M, Latitude_Initial_RAD
                , Radius_Small_Circle_Latitude_M, Longitude_Initial_RAD),
     Pre => Radius_Meridional_M > 0.0
     and  Radius_Small_Circle_Latitude_M > 0.0;

   --  ////////////////////////////////////////////////////////////////////////////
   --  ///////     LINEAR DISTANCES

   --  Long_float dGetLinearDistance_m_Lat1Long1_RAD_To_Lat2Long2_rad(const Long_float& dLatitude1_rad, const Long_float& dLongitude1_rad, const Long_float& dLatitude2_rad, const Long_float& dLongitude2_rad);
   procedure Get_Linear_Distance_M_Lat1_Long1_RAD_To_Lat2_Long2_RAD
     (Latitude_1_RAD    : in  RAD_Latitude;
      Longitude_1_RAD   : in  RAD_Angle;
      Latitude_2_RAD    : in  RAD_Latitude;
      Longitude_2_RAD   : in  RAD_Angle;
      Linear_Distance_M : out Long_Float);


   --  Long_float dGetLinearDistance_m_Lat1Long1_deg_To_Lat2Long2_deg(const Long_float& dLatitude1_deg, const Long_float& dLongitude1_deg, const Long_float& dLatitude2_deg, const Long_float& dLongitude2_deg);
   procedure Get_Linear_Distance_M_Lat1_Long1_DEG_To_Lat2_Long2_DEG
     (Latitude_1_DEG    : in  DEG_Latitude;
      Longitude_1_DEG   : in  DEG_Angle;
      Latitude_2_DEG    : in  DEG_Latitude;
      Longitude_2_DEG   : in  DEG_Angle;
      Linear_Distance_M : out Long_Float);



   --  // WGS-84 parameters
   --  const Long_float m_dRadiusEquatorial_m{6378135.0};
   Radius_Equatorial_M  : constant Long_Float := 6378135.0;
   --  const Long_float m_dFlattening{3.352810664724998e-003};
   Flattening           : constant Long_Float := Long_Float (0.003352810664724998);
   --  const Long_float m_dEccentricitySquared{6.694379990096503e-003};
   Eccentricity_Squared : constant Long_Float := Long_Float (0.006694379990096503);
   
   subtype Meridional_Radius_Unit   is Long_Float range 6300000.0 .. 8000000.0;
   subtype Transverse_Radius_Unit   is Long_Float range 6300000.0 .. 7090000.0;
   subtype Small_Circle_Radius_Unit is Long_Float range 0.001     .. 7090000.0;

   Latitude_Initial_RAD           : RAD_Latitude     := 0.0;   --  double CUnitConversions::m_dLatitudeInitial_rad{0.0};
   Longitude_Initial_RAD          : RAD_Angle        := 0.0;   --  double CUnitConversions::m_dLongitudeInitial_rad{0.0};
   Radius_Meridional_M            : Meridional_Radius_Unit   := 6500000.0;   --  double CUnitConversions::m_dRadiusMeridional_m{0.0};
   Radius_Transverse_M            : Transverse_Radius_Unit   := 6500000.0;   --  double CUnitConversions::m_dRadiusTransverse_m{0.0};
   Radius_Small_Circle_Latitude_M : Small_Circle_Radius_Unit := 0.1;   --  double CUnitConversions::m_dRadiusSmallCircleLatitude_m{0.0};
   B_Initilized                   : Boolean := False;    --  bool   CUnitConversions::m_bInitialized{false};

end Uxas.Common.Utilities.Unit_Conversions;
