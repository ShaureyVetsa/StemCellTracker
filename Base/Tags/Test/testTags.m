%%%%%%%%%%%%%%%%%
%%% Test Tags %%%
%%%%%%%%%%%%%%%%%

clc
clear all
close all

initialize


%% tagformat2tagnames

texpr = 'test_T<tag1>-<tag2, 5>-<tag1,3>.tif';
[tnames, tagsplit, taginfo] = tagExpressionToTagNames(texpr)

taginfo(1)


%% tagexpr2string
tagExpressionToString(texpr, 'tag1', 2, 'tag2',  5)
tagExpressionToString(texpr, 'tag1', 2)


%% taginfo2tagexpr

taginfo(1).tag = strrep(taginfo(1).tag, taginfo(1).name, 'test');
taginfo(1).name = 'test';

tagInfoToTagExpression(tagsplit, taginfo)


%% reducing tags

texpr = 'test_T<tag1>-<tag2, 5>-<tag1,3><tag3>.tif';

clear tags
tags(1).tag1 = 3;
tags(2).tag1 = 2;
val = {1,2};
[tags.tag2] = val{:};
[tags.tag3] = val{:};
[tags.tag4] = val{:};

tagsnew = tagsReduce(tags)


%%
clc
[tagsnew, texprnew] = tagsReduce(tags, texpr)


%% tagexpr2tags

clc
texpr = 'test_T<tag1>-<tag2, 5>-<tag1,3>_<tag3>.tif';
name  = 'test_T01-00003-001_19.tif';
tagExpressionToTags(texpr, name)

%%
name  = {'test_T01-00003-001_19.tif', 'test_T01-00004-001_20.tif'};
tags = tagExpressionToTags(texpr, name)

tags(2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% tagexpr: infer tags from list names or files

clc
[texpr, tnames, tags] = tagExpression('./Test/Images/hESCells_Tiling/*', 'tagnames', {'field', 'test'})
[tags.field]

%%
clc
[texpr, tnames, tags] = tagExpression('./Test/Images/hESCells_Stack/*', 'tagnames', 'z')

[tags.z]

%%
clc
[texpr, tnames, tags] = tagExpression('./Test/Images/mESCells_Wnt/*', 'tagnames', {'t', 'z'});

texpr
tags

tags(5)


%% more complicated file stucture

dirr('./Test/Images/hESCells_Folder/*/*.tif')


%%
[texpr, tnames, tags] = tagExpression('./Test/Images/hESCells_Folder/*/*.tif', 'reduce', false);

texpr
tags

[tags.tag1]
[tags.tag2]
[tags.tag3]
[tags.tag4]


%%
clc
[texpr, tnames, tags] = tagExpression('./Test/Images/hESCells_Folder/*/*.tif', 'reduce', true, 'tagnames', {'t1', 't2'})

%%
clc
texpr = './Test/Images/hESCells_Folder/f<tag1,1>_t<tag2,1>/f<tag1,1>_t<tag2,2>_z<tag3,2>.tif';

tagExpressionToFiles(texpr)

tagExpressionToFileExpression(texpr)

%% tagexpr2files - remove no consistent file names if multiple occurences of tags
clc

texpr = './Test/Images/hESCells_Folder/f<tag1,1>_t<tag2,1>/f<tag1,1>_t<tag2,2>_z<tag3,2>.tif';

dirr(tagExpressionToFileExpression(texpr))
tagExpressionToFiles(texpr)
tagExpressionToFiles(texpr, 'check', true)

% note: the latter matches all 

%% tagexpr2tags: automatically find filenames

tags = tagExpressionToTags(texpr)

tags(5)

 
 
 
%%

texpr = './Test/Images/hESCells_Folder/f<tag1,1>_t<tag2,1>/f<tag1,1>_t<tag2,2>_z<tag3,2>.tif';
[tnames, tagsplit, taginfo] = tagExpressionToTagNames(texpr)

%% - type mismatch error

clc
texpr = './Test/Images/hESCells_Folder/f<tag1,d,5>_t<tag2,1>/f<tag1,s,5>_t<tag2,2>_z<tag3,2>.tif';
 
[tnames, tagsplit, taginfo] = tagExpressionToTagNames(texpr)


%% - size mismatch error
clc
texpr = './Test/Images/hESCells_Folder/f<tag1,s,5>_t<tag2,1>/f<tag1,s,3>_t<tag2,2>_z<tag3,2>.tif';
 
[tnames, tagsplit, taginfo] = tagExpressionToTagNames(texpr)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% tags2tagranges


tags = tagExpressionToTags('./Test/Images/hESCells_Folder/f<tag1>_t<tag2,1>/f<tag1>_t<tag2,2>_z<tag3,2>.tif')

trs = tagRangeFromTags(tags)

tagRangeSize(trs)

tgs = tagRangeToTags(trs)


%% tags not multipicative -> should produce error

tagRangeFromTags(tags, 'check', true)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% test some regular expressions
texpr = 'test_T<tag1>-<tag2, 5>.tif';

tt = regexp(texpr, '<(?<name>\w*)\s*(?<k>(,\s*\d*?|\s*?))\s*>', 'names')
{tt.name}
{tt.k}

%%


tt = regexp(texpr, '(?<repl><.*?,*\s*?\d*?\s*?>)', 'names')
tt.repl


%% check for consistency

clc
texpr = './Test/Images/hESCells_Folder/f<tag1,1>_t<tag2,1>/f<tag1,1>_t<tag2,2>_z<tag3,2>.tif';

fname1 = './Test/Images/hESCells_Folder/f1_t1/f1_t01_z01.tif';
 
re = tagExpressionToRegularExpression(texpr)
regexp(fname1, re, 'names')


fname2 = './Test/Images/hESCells_Folder/f2_t1/f3_t02_z02.tif';
regexp(fname2, re, 'names')
 

tagExpressionToTags(texpr, fname1)
tagExpressionToTags(texpr, fname2)




%% TagRanges

clc
tr.tag1 = {1,2,3,4,5};
tr.tag2 = {'a', 'b', 'c'};

tsi = tagRangeSize(tr)

prod(tsi)

tvs = tagValuesFromIndex(tr, 6)


%% Index Ranges 

clc
tgr.x = {1,2,3};
tgr.c = {'a', 'b', 'c'};

tgi.x= 1;
tgi.c =2:3;

tg = tagRangeFromTagIndexRange(tgr, tgi)

tagRangeToTagIndexRange(tgr, tg)


%% first and last

tg = tagExpressionToTags('<a>f<b>', {'1f4', '5f8'});

[tg.a]
[tg.b]


%%
clc
tagRangeFromFirstAndLastString('<a>f<b>', '1f4', '5f8')



%%

% note we use greedy matching
tg = tagExpressionToTags('<a, s>f<b,s>', {'gaffc', 'afab'})


{tg.a}
{tg.b}


%% tag range

clc
tagRangeFromTagExpression('./Test/Images/hESCells_Folder/f<tag1>_t<tag2,1>/f<tag1>_t<tag2,2>_z<tag3,2>.tif', 'tag3', 1)



 
