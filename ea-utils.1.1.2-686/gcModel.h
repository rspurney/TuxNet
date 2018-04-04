/*
$Id: gcModel.h 556 2013-03-01 15:32:36Z earonesty $
*/
extern void gcInit(int maxReadLength);
extern void gcProcessSequence(int l,int c);
extern void gcPrintDistribution(FILE *fp);
void gcClose();
