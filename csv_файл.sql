create table SHL (Person_ID int primary key not null,Gender varchar(7),Age int ,Occupation varchar(30),Sleep_Duration float,Quality_of_Sleep int,Physical_Activity_Level int,Stress_Level int,BMI_Category varchar(20),Blood_Pressure varchar(10),Heart_Rate int,Daily_Steps int,Sleep_Disorder varchar(30));
select * from SHL;

select * from SHL where Person_ID > 350;

select person_id, gender, age from SHL where Sleep_Duration=8 and Quality_of_Sleep=9 and Occupation='Nurse';

insert into SHL values(376, 'Male', 31, 'Software Engineer', 5.3, 6, 40, 8, 'Normal', 118/70, 90, 14000, 'Sleep Apnea');

update SHL set age=age+1 where Sleep_Duration=8 and Quality_of_Sleep=9 and Occupation='Nurse';

delete from SHL where Person_ID=376;

select Occupation, count(Physical_Activity_Level) from SHL
group by Occupation;

select Physical_Activity_Level, 
       AVG(Heart_Rate), 
       MAX(Daily_Steps), 
       COUNT(Physical_Activity_Level) 
from SHL 
group by Physical_Activity_Level 
order by COUNT(Physical_Activity_Level) desc;