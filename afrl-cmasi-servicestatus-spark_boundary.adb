package body Afrl.Cmasi.ServiceStatus.SPARK_Boundary with SPARK_Mode => Off is

   
   --------------------
   --  Get_KeyPairs  --
   --------------------
       
   function Get_KeyPairs
     (This : My_ServiceStatus) return Vect_KeyValuePair
   is 
      L : constant Afrl.Cmasi.ServiceStatus.Vect_KeyValuePair_Acc_Acc :=
        This.Content.GetInfo;
   begin
      
      return R : Vect_KeyValuePair do
         for E of L.all loop
            Vect_KeyValuePair_P.Append(Container => R,
                                       New_Item  => E.all);
         end loop;
      end return;
   end Get_KeyPairs;
   
   ----------------------
   --  Set_StatusType  --
   ----------------------
    
   procedure Set_StatusType
     (This : in out My_ServiceStatus ;
      StatusType  : ServiceStatusTypeEnum ) 
   is 
   begin
      This.Content.SetStatusType  ( StatusType );
   end Set_StatusType ;
      
   
   -------------------
   --  Add_KeyPair  --
   -------------------
    
   procedure Add_KeyPair
     (This : in out My_ServiceStatus ;
      KeyPair_Key  : Unbounded_String;
      KeyPair_Value : Unbounded_String) 
   is
      Key_Pair : constant KeyValuePair_Acc := new KeyValuePair.KeyValuePair;
   begin
      Key_Pair.SetKey(KeyPair_Key);
      Key_Pair.SetValue(KeyPair_Value);
      This.Content.GetInfo.Append(Key_Pair);
   end Add_KeyPair;
   
   -------------------
   --  Add_KeyPair  --
   -------------------
         
   procedure Add_KeyPair
     (This : in out My_ServiceStatus ;
      KeyPair_Key  : Unbounded_String) 
   is
      Key_Pair : constant KeyValuePair_Acc := new KeyValuePair.KeyValuePair;
   begin
      Key_Pair.SetKey(KeyPair_Key);
      This.Content.GetInfo.Append(Key_Pair);
   end Add_KeyPair;
   
end Afrl.Cmasi.ServiceStatus.SPARK_Boundary;
