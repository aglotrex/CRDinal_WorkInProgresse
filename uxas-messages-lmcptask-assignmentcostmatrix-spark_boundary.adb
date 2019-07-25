package body UxAS.Messages.Lmcptask.ASsignmentCostMatrix.SPARK_Boundary with SPARK_Mode => Off is

   function Get_CostMatrix 
     (This : My_AssignmentCostMatrix) return Vect_My_TaskOptionCost
   is 
      L : constant UxAS.Messages.Lmcptask.AssignmentCostMatrix.Vect_TaskOptionCost_Acc_Acc :=
        This.Content.GetCostMatrix;
   begin
      return R : Vect_My_TaskOptionCost do
         for E of L.all loop
            Vect_My_TaskOptionCost_V.Append(Container => R,
                                            New_Item  => Wrap (E.all));
         end loop;
      end return;
   end Get_CostMatrix;
   
   function Get_TaskList (This : My_AssignmentCostMatrix) return Int64_Vect
   is
      L : constant Vect_Int64_Acc := This.Content.GetTaskList;
   begin
      return R : Int64_Vect do
         for E of L.all loop
            Int64_Vects.Append (R, E);
         end loop;
      end return;
   end Get_TaskList;
   
   
   procedure Add_TaskOptionCost_To_CostMatrix
     (This : in out My_AssignmentCostMatrix;
      Task_OptionCost : My_TaskOptionCost)
   is 
      Task_Option_Cost_Acc : constant TaskOptionCost_Acc := new TaskOptionCost.TaskOptionCost;
   begin
      Task_Option_Cost_Acc.all := Unwrap(Task_OptionCost); 
      Vect_TaskOptionCost_Acc.Append (Container => This.Content.GetCostMatrix.all,
                                      New_Item  => Task_Option_Cost_Acc);
     
   end Add_TaskOptionCost_To_CostMatrix;
   
   
       
   procedure Set_CorrespondingAutomationRequestID
     (This : in out My_AssignmentCostMatrix;
      CorrespondingAutomationRequestID : Int64) 
   is 
   begin
      This.Content.SetCorrespondingAutomationRequestID (CorrespondingAutomationRequestID);
   end Set_CorrespondingAutomationRequestID;
   
   procedure Set_OperatingRegion
     (This : in out My_AssignmentCostMatrix;
      OperatingRegion : Int64) 
   is 
   begin
      This.Content.SetOperatingRegion (OperatingRegion);
   end Set_OperatingRegion;
   
        
   procedure Set_TaskLevelRelationship
     (This : in out My_AssignmentCostMatrix;
      TaskLevelRelationship : Unbounded_String) 
   is 
   begin
      This.Content.SetTaskLevelRelationship (TaskLevelRelationship);
   end Set_TaskLevelRelationship;
   
        
   procedure Set_TaskList
     (This : in out My_AssignmentCostMatrix;
      TaskList : Int64_Vect) 
   is
     
      Task_List : constant Vect_Int64_Acc := new Vect_Int64.Vector'(Vect_Int64.Empty_Vector);
   begin 
      for E in First_Index(TaskList) .. Last_Index(TaskList) loop
         declare 
            TaskID : constant Int64 := Element ( TaskList , E);
         begin
            Vect_Int64.Append (Container => Task_List.all,
                               New_Item  => TaskID);
         end;
      end loop;
      This.Content.TaskList := Task_List;
   end Set_TaskList;
   

end UxAS.Messages.Lmcptask.ASsignmentCostMatrix.SPARK_Boundary;
