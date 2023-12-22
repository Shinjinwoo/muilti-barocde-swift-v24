//
//  NexacroData.h
//  Nexacro
//
//  Created by Jaehyung on 13. 2. 4..
//
//

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"

#define NEXACRO_DATATYPE_UNDEFINED  0
#define NEXACRO_DATATYPE_STRING     1
#define NEXACRO_DATATYPE_INT        2
#define NEXACRO_DATATYPE_FLOAT      3
#define NEXACRO_DATATYPE_DOUBLE     NEXACRO_DATATYPE_FLOAT
#define NEXACRO_DATATYPE_DECIMAL    4
#define NEXACRO_DATATYPE_BIGDECIMAL NEXACRO_DATATYPE_DECIMAL
#define NEXACRO_DATATYPE_DATE       5
#define NEXACRO_DATATYPE_TIME       6
#define NEXACRO_DATATYPE_DATETIME   7
#define NEXACRO_DATATYPE_BLOB       8
#define NEXACRO_DATATYPE_VARIANT    9

#define NEXACRO_SUMMARYTYPE_NONE  0
#define NEXACRO_SUMMARYTYPE_COUNT 1
#define NEXACRO_SUMMARYTYPE_SUM   2
#define NEXACRO_SUMMARYTYPE_MAX   3
#define NEXACRO_SUMMARYTYPE_MIN   4
#define NEXACRO_SUMMARYTYPE_AVG   5
#define NEXACRO_SUMMARYTYPE_TEXT  6

#define NEXACRO_ENCRYPTTYPE_NONE   0
#define NEXACRO_ENCRYPTTYPE_BASE64 1

/*!
 * @class Parameter
 * @discussion
 */
@interface Parameter : NSObject {
    NSString* parameterId;
    int parameterType;
    NSObject* parameterValue;
}

@property (nonatomic,readwrite,retain) NSString* parameterId;
@property (nonatomic,readwrite) int parameterType;
@property (nonatomic,readwrite,retain) NSObject* parameterValue;

- (id) initWithParameterId:(NSString*) paramId andParameterValue:(NSObject*) paramValue;
- (id) initWithParameterId:(NSString*) paramId andParameterType:(int) paramType andParameterValue:(NSObject*) paramValue;
- (id) initWithDictionary:(NSDictionary*) dictionary;

+ (Parameter*) parameterWithParameerId:(NSString*) paramId andParameterValue:(NSObject*) paramValue;
+ (Parameter*) parameterWithParameerId:(NSString*) paramId andParameterType:(int) paramType andParameterValue:(NSObject*) paramValue;
+ (Parameter*) parameterDictionary:(NSDictionary*) dictionary;

- (NSString*) convertJSONString;
- (void) loadFromDictionary:(NSDictionary*) dictionary;
@end

/*!
 * @class Column
 * @discussion
 */
@interface Column : NSObject {
    NSString* columnId;
    int columnType;
    int columnSize;
    int summaryType;
    int encryptType;
}

@property (nonatomic,readonly,retain) NSString* columnId;
@property (nonatomic,readwrite) int columnType;
@property (nonatomic,readwrite) int columnSize;
@property (nonatomic,readwrite) int summaryType;
@property (nonatomic,readwrite) int encryptType;

- (id) initWithColumnId:(NSString*) colId andColumnType:(int) colType;
- (id) initWithColumnId:(NSString*) colId andColumnType:(int) colType andColumnSize:(int) colSize;

+ (Column*) columnWithColumnId:(NSString*) colId andColumnType:(int) colType;
+ (Column*) columnWithColumnId:(NSString*) colId andColumnType:(int) colType andColumnSize:(int) colSize;
@end

/*!
 * @class NexacroDataset
 * @discussion
 */
@interface NexacroDataset : NSObject {
    NSString* datasetId;
    MutableOrderedDictionary* constColumns;
    MutableOrderedDictionary* columns;
    NSMutableArray* rows;
}

@property (nonatomic,readonly,retain) NSString* datasetId;
@property (nonatomic,readwrite,retain) MutableOrderedDictionary* constColumns;
@property (nonatomic,readwrite,retain) MutableOrderedDictionary* columns;
@property (nonatomic,readwrite,retain) NSMutableArray* rows;

- (id) initWithDatasetId:(NSString*) dataId;

+ (NexacroDataset*) datasetWithDatasetId:(NSString*) dataId;

- (NSString*) convertJSONString;
- (void) loadFromDictionary:(NSDictionary*) dictionary;
@end

/*!
 * @class NexacroData
 * @discussion
 */
@interface NexacroData : NSObject {
    NSMutableDictionary* parameters;
    NSMutableDictionary* datasets;
}

@property (nonatomic,readwrite,retain) NSMutableDictionary* parameters;
@property (nonatomic,readwrite,retain) NSMutableDictionary* datasets;

- (id) init;

+ (NexacroData*)data;

+ (NSString*) encodeString:(NSString*) source;
+ (NSString*) decodeString:(NSString*) source;
@end
