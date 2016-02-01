clear;
y=randn(2,5)
Position(1).Location = [5;5];
Position(1).Cov = diag([2 2]);
Position(1).Parent = 0;
Position(1).maxnodParent = 0;
Position(1).Genartion=0;
Position(1).tag=1;

mincount=1;
recordmin=1;
u=2;
for count=u:u+3 
 Position(count).Parent = 0; 
 Position(count).maxnodParent = 1;
 Position(count).Location = Position(1).Location+[-1/6;0]*(count-u-1)*(count-u-2)*(count-u-3)+[-1/2;0]*(count-u)*(count-u-2)*(count-u-3)+[0;-1/2]*(count-u)*(count-u-1)*(count-u-3)+[0;-1/6]*(count-u)*(count-u-1)*(count-u-2);;
 Position(count).Cov = Position(count-1).Cov;
 Position(count).tag=1;
 Position(count).Genartion=1;
 
        for t=1:5
             nodecov(mincount).Parent=count;
             nodecov(mincount).Cov = kalmanRiccatiY(Position(count).Location,y(:,t),Position(count).Cov);
             nodecov(mincount).det=det(nodecov(mincount).Cov);
             nodecov(mincount).tag=0;
             nodecov(mincount).Genartion= Position(nodecov(mincount).Parent).Genartion+1;
             mincount=mincount+1;
         end
 
end


mincount=mincount-1;
recordmax=mincount;
recordmin=1;
tag=1; %generate the Max tree, if tag=0, generate Min tree

number_max_node_each_generation=4;
number_min_node_each_generation=20;
genartion=3;

startnum_min=1;
startnum_max=6;
tag_min=startnum_min;
endnum_min=20;


 while Position(count-1).Genartion <7
     if tag ==1  %generate the Max tree
         
             record_max=count+1; %record the initial number of max tree ��¼���max������һ���ĵ�һ�����Ա���mintree���ɵ�ʱ����Ϊ���ĵ���
         for i=1:number_min_node_each_generation
             
             k=count+1;
             for count=k:k+3
                Position(count).Parent = fix(startnum_min); %startnum_min��������ĵ���startnum_minһ��ʼ����һ��min�ĵ�һ��Ԫ�صı��
                Position(count).maxnodParent=nodecov(Position(count).Parent).Parent;
                Position(count).Location = Position(Position(count).maxnodParent).Location+[-1/6;0]*(count-k-1)*(count-k-2)*(count-k-3)+[-1/2;0]*(count-k)*(count-k-2)*(count-k-3)+[0;-1/2]*(count-k)*(count-k-1)*(count-k-3)+[0;-1/6]*(count-k)*(count-k-1)*(count-k-2);
                Position(count).Cov = Position(count-1).Cov;
                Position(count).tag=1;
                Position(count).Genartion=genartion;
                
                
                startnum_min=startnum_min+0.25;%�������startnum_min�Ƶ�����һ�������һ���ڵ�
             end
         end
         
         startnum_max=record_max;%��¼����һ��max�ڵ�ĵ�һ��
         genartion=genartion+1;
         number_max_node_each_generation=4*number_min_node_each_generation;
         tag=0;
         
         
     else         %generate the Max tree
         
         
       record_min=mincount+1; %record the initial number of Max tree ��¼���min������һ���ĵ�һ�����Ա���maxtree���ɵ�ʱ����Ϊ���ĵ���
         for i=1:number_max_node_each_generation
             
              k=mincount+1;
             for mincount=k:k+4
                 
                  nodecov(mincount).Parent=fix(startnum_max+0.1);
                  nodecov(mincount).Cov = kalmanRiccatiY(Position(count).Location,y(:,mincount-k+1),Position(count).Cov);
                  nodecov(mincount).det=det(nodecov(mincount).Cov);
                  nodecov(mincount).tag=0;
                  nodecov(mincount).Genartion= Position(nodecov(mincount).Parent).Genartion+1;
      
                  startnum_max=startnum_max+0.2;
                  
             end
             

         end
         
         
         startnum_min=record_min;%��¼����һ��min�ڵ�ĵ�һ��
         genartion=genartion+1;
         number_min_node_each_generation=5*number_max_node_each_generation;
         tag=1;
         
     end
         
         

 end