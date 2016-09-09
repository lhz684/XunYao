//
//  DataBaseManager.m
//  GuPiao
//
//  Created by 刘怀智 on 15/12/22.
//  Copyright © 2015年 lhz. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDB.h"
#define dataBasePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:dataBaseName]///<数据库路径

#define dataBaseName @"Medicines.db"///<数据库名
#define KTableYao @"medicines"///<表名
#define KTableType @"type"///<表名
@interface DataBaseManager()
@property (strong,nonatomic)FMDatabase *dataBase;///<fmdb
@end
@implementation DataBaseManager

+(instancetype)defaultManager{
//数据库manager 单列模式
    static DataBaseManager *theManager = nil;
    @synchronized (self) {
        if (theManager == nil) {
            theManager = [[DataBaseManager alloc]init];
        }
    }
    return theManager;
}
-(instancetype)init{
    if (self=[super init]) {
        
        self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
        if ([self.dataBase open]==NO) {
            NSLog(@"打开数据库失败，数据库路径： %@",dataBasePath);
            return nil;
        }
        else{
            NSLog(@"打开数据库成功，数据库路径： %@",dataBasePath);
            
        }
        NSString *sqlStr=[NSString stringWithFormat:@"create table if not exists %@ (name text,id text, about text,message text,image blob,isAdd int)",KTableYao];
        if (![self.dataBase executeUpdate:sqlStr]) {
            NSLog(@"建详情 类别表失败啊，SQL语句是：%@",sqlStr);
            return nil;
        }
        NSString *sqlStr1=[NSString stringWithFormat:@"create table if not exists %@ (name text,id text)",KTableType];
        if (![self.dataBase executeUpdate:sqlStr1]) {
            NSLog(@"建分类 类别表失败啊，SQL语句是：%@",sqlStr1);
            return nil;
        }

    }
    return self;
}

-(void)addYao:(medicine *) medicine///<存数据
{
    if (!medicine) {
        return;///<如果传入的对象为空，则跳出
    }
    
        [self deleteYao:medicine.ID.stringValue];///<删除数据库中的已有的数据
        NSNumber *isadd = @(0);
        isadd = @(medicine.isAdd?:0);
        ///< 判断传入的股票是否已经添加自选股 ， 没有则添加（三目运算 a＝b?:c a不等于b就将b赋值给a ，a等于b就将c赋值给a）
        NSString *sqlStr=[NSString stringWithFormat:@"insert into %@ (name,id,about,message,image,isAdd) values (?,?,?,?,?,?)",KTableYao];
        if (![self.dataBase executeUpdate:sqlStr,medicine.name,medicine.ID.stringValue,medicine.about,medicine.message,medicine.imageData,isadd]) {
            NSLog(@"添加详情失败，sq语句是：%@",sqlStr);
        
    }
}
-(void)addType:(NSMutableArray *)array
{
    if (!array) {
        return;///<如果传入的对象为空，则跳出
    }
    
    for (type *type in array) {
        
        [self deleteType:type.typeID.stringValue];///<删除数据库中的已有的数据
     
        NSString *sqlStr=[NSString stringWithFormat:@"insert into %@ (name,id) values (?,?)",KTableType];
        if (![self.dataBase executeUpdate:sqlStr,type.typeName,type.typeID.stringValue]) {
            NSLog(@"添加分类失败，sq语句是：%@",sqlStr);
            return;
    }
        
    }
}
-(void)deleteYao:(NSString *)code
///<删除数据
{
    NSString *sqlStr1 = [NSString stringWithFormat:@"delete from %@ where id  = '%@'",KTableYao,code];
    if (![self.dataBase executeUpdate:sqlStr1]){
        NSLog(@"删除详情失败");
    }
}
-(void)deleteType:(NSString *)code
///<删除数据
{
    NSString *sqlStr1 = [NSString stringWithFormat:@"delete from %@ where code  = '%@'",KTableType,code];
    if (![self.dataBase executeUpdate:sqlStr1]){
        NSLog(@"删除分类失败");
    }
}
-(NSMutableArray *)readYao{///<读取详情数据
    
    NSMutableArray *medicineArray = [[NSMutableArray alloc]init];
    NSString *sqlStr=[NSString stringWithFormat:@"select * from %@  ",KTableYao];
    FMResultSet *resulsts=[self.dataBase executeQuery:sqlStr];
    
    while ([resulsts next]) {

        medicine *amedicine = [[medicine alloc]init];
        amedicine.name = [NSString stringWithFormat:@"%@",[resulsts stringForColumn:@"name"]];
        amedicine.ID = @([resulsts intForColumn:@"id"]);
        amedicine.about = [NSString stringWithFormat: @"%@",[resulsts stringForColumn:@"about"]];
        amedicine.message = [NSString stringWithFormat:@"%@",[resulsts stringForColumn:@"message"]];
        amedicine.imageData = [resulsts dataForColumn:@"image"];
        amedicine.isAdd = [resulsts intForColumn:@"isadd"];
        
        [medicineArray addObject:amedicine];///<存入数组
    }
    
    return [medicineArray mutableCopy];///<反回数组
}
-(NSMutableArray *)readType{
    NSMutableArray *typeArray = [[NSMutableArray  alloc]init];
    NSString *sqlStr=[NSString stringWithFormat:@"select * from %@  ",KTableType];
    FMResultSet *resulsts=[self.dataBase executeQuery:sqlStr];
    
    while ([resulsts next]) {
        type *atype = [[type alloc]init];
        atype.typeName = [NSString stringWithFormat:@"%@",[resulsts stringForColumn:@"name"]];
        atype.typeID = @([resulsts intForColumn:@"id"]);
        
        [typeArray addObject:atype];
    }
    return [typeArray copy];
}
-(NSUInteger)countOfType{///<获取类别个数

    NSString *sqlStr=[NSString stringWithFormat:@"select count(*) from %@ ",KTableType];
    return [self.dataBase intForQuery:sqlStr];
}
@end
