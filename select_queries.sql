use vaxdb;
 
######1
Select distinct p.SSN,p.Name,
	(select count(distinct u.stay) from undergoes u where u.patient=p.SSN ) AS totalStays,
    (select sum(distinct t.cost) from treatment t, undergoes u where u.treatment=t.code and u.patient=p.SSN) AS totalCost
	from patient p where p.Age>=30 and p.Age<=40 and p.Gender='male' 
    having totalStays>1;
    
######2
select distinct n.EmployeeID, n.Name from nurse n, on_call oc where n.EmployeeID=oc.nurse
	and 1<(select count(distinct oc.BlockCode) from on_call oc where n.EmployeeID=oc.nurse and oc.BlockFloor>3 
			and oc.BlockFloor<8 and oc.OnCallStart>='2008-04-20 23:22:00' and oc.OnCallEnd<= '2009-06-04 11:00:00' )
	order by n.EmployeeID;

######3
select distinct p.SSN, p.Name from patient p where p.Gender='female' and p.Age>40
	and (select count(vac.patient_SSN) from vaccination vac where vac.patient_SSN=p.SSN) = 
    (select distinct v.num_of_doses from vaccines v,vaccination vac where vac.patient_SSN=p.SSN and vac.vaccines_vax_name=v.vax_name);

######4
select m.Name,m.Brand ,
		(select count(distinct p.patient) from prescribes p where p.medication=m.Code) as Patients
        from medication m
        having Patients>1;
######5
select distinct p.SSN, p.Name from patient p where 
	(select count(distinct vac.patient_SSN) from vaccination vac where vac.patient_SSN=p.SSN) = 
    (select count(distinct vac.physician_EmployeeID) from vaccination vac where vac.patient_SSN=p.SSN );

######6
select distinct "yes" as answer from stay s where s.StayStart>='2013-01-01 00:00:00' and s.StayStart<'2014-01-01 00:00:00' and
		exists (select count(*) from room r where r.roomNumber=s.room and r.Unavailable)
union
select distinct "no" as answer from stay s where s.StayStart>='2013-01-01 00:00:00' and s.StayStart<'2014-01-01 00:00:00' and
		not exists (select count(*) from room r where r.roomNumber=s.room and r.Unavailable);

######7
select  ph.EmployeeID, ph.Name,
			(select count(distinct u.patient) from undergoes u
            where u.physician in (select ti.physician	from trained_in ti where ti.Speciality in  (select code from treatment where name='PATHOLOGY'))
            and u.physician=ph.EmployeeID) As NumOfPatient			
				from  physician ph, trained_in ti where ph.EmployeeID=ti.Physician and ti.Speciality in (select code from treatment where name='PATHOLOGY');
            
######8
select distinct p.SSN, p.Name from patient p where
	(select count(vac.patient_SSN) from vaccination vac where vac.patient_SSN=p.SSN) <
    (select distinct v.num_of_doses from vaccines v,vaccination vac where vac.patient_SSN=p.SSN and vac.vaccines_vax_name=v.vax_name);
    
######9
select max(vaccines_vax_name)  from vaccination vac;

######10
select ph.Name from  physician ph,trained_in ti where ph.EmployeeID=ti.Physician 
			and (select count(tr.code) from treatment tr where tr.name='RADIATION ONCOLOGY') = 
            (select count(ti.Speciality) from trained_in ti where ph.EmployeeID=ti.Physician and ti.Speciality in (select code from treatment where name='RADIATION ONCOLOGY'))
            group by ph.Name;
