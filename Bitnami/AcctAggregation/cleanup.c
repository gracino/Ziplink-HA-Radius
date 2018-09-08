/*
 * FILE
 * 	cleanup.c
 * PURPOSE
 * 	close open radacct records
 * HOW IT WORKS
 * 	find usernames that have open duplicate sessions
 * 	set acctstoptime of prev latest records to latest record acctuupdatettime
 * BEFORE DOCKER BUILD COMPILE
 * 	gcc cleanup.c -lmysqlclient -L/lib64/mysql
*/

#include <stdio.h>
#include <mysql/mysql.h>

int main(int iArgCount, char *cArgVars[])
{

	if(iArgCount!=4)
	{
		printf("usage: %s <host> <login> <password>\n",cArgVars[0]);
		return(0);
	}

	MYSQL Mysql;
	mysql_init(&Mysql);
	if(!mysql_real_connect(&Mysql,cArgVars[1],cArgVars[2],cArgVars[3],"radius",0,NULL,0))
	{
		printf("Could not connect\n");
		return(1);
	}
	printf("Connected\n");


	//Create a list of sessions with same username
	char cQuery[1024];
	sprintf(cQuery,"SELECT username FROM radacct WHERE acctstoptime IS NULL GROUP BY username HAVING count(username)>1");
	mysql_query(&Mysql,cQuery);
	if(mysql_errno(&Mysql))
	{
		printf("%s\n",mysql_error(&Mysql));
		return(2);
	}

	MYSQL_RES *mysqlRes;
	MYSQL_ROW mysqlField;
	MYSQL_RES *mysqlRes2;
	MYSQL_ROW mysqlField2;

	unsigned uTargetRadAcctID=0;
	char cPrevAcctUpdateTime[32]={""};

	mysqlRes=mysql_store_result(&Mysql);
        while((mysqlField=mysql_fetch_row(mysqlRes)))
	{
		uTargetRadAcctID=0;
		cPrevAcctUpdateTime[0]=0;

        	printf("%s\n",mysqlField[0]);
		sprintf(cQuery,"SELECT radacctid,acctstarttime,acctupdatetime FROM radacct"
				" WHERE username='%s' AND acctstoptime IS NULL"
				" ORDER BY acctupdatetime DESC LIMIT 2",mysqlField[0]);
		mysql_query(&Mysql,cQuery);
		if(mysql_errno(&Mysql))
		{
			printf("%s\n",mysql_error(&Mysql));
			return(2);
		}
		mysqlRes2=mysql_store_result(&Mysql);
        	if((mysqlField2=mysql_fetch_row(mysqlRes2)))
		{
			if(mysqlField2[0]!=NULL && mysqlField2[1]!=NULL && mysqlField2[2]!=NULL)
			{
        			printf("%s %s %s\n",mysqlField2[0],mysqlField2[1],mysqlField2[2]);
			}
			else
			{
        			printf("NULL found\n");
				return(3);
			}
			sprintf(cPrevAcctUpdateTime,"%.31s",mysqlField2[2]);
		}
        	if((mysqlField2=mysql_fetch_row(mysqlRes2)))
		{
			if(mysqlField2[0]!=NULL && mysqlField2[1]!=NULL && mysqlField2[2]!=NULL)
			{
        			printf("%s %s %s\n",mysqlField2[0],mysqlField2[1],mysqlField2[2]);
			}
			else
			{
        			printf("NULL found\n");
				return(3);
			}
			sscanf(mysqlField2[0],"%u",&uTargetRadAcctID);
		}
		mysql_free_result(mysqlRes2);

		if(cPrevAcctUpdateTime[0] && uTargetRadAcctID)
		{
			sprintf(cQuery,"UPDATE radacct SET acctstoptime='%s' WHERE radacctid=%u",cPrevAcctUpdateTime,uTargetRadAcctID);
			mysql_query(&Mysql,cQuery);
			if(mysql_errno(&Mysql))
			{
				printf("%s\n",mysql_error(&Mysql));
				return(4);
			}
			if(mysql_affected_rows(&Mysql)==1)
				printf("%u had it's acctstoptime set to %s\n",uTargetRadAcctID,cPrevAcctUpdateTime);
			else
				printf("%u tried to have it's acctstoptime set to %s, but it failed!\n",uTargetRadAcctID,cPrevAcctUpdateTime);
		}
	}
	mysql_free_result(mysqlRes);


	return(0);
}//main()
