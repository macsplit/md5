#import "Md5.h"

@implementation Md5

#define LEFTROTATE(x, c) (((x) << (c)) | ((x) >> (32 - (c))))

uint32_t h0, h1, h2, h3;

void calcmd5(uint8_t *initial_msg, size_t initial_len) {
    
    uint8_t *msg = NULL;
    
    uint32_t r[] = {7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
                   5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20,
                   4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
                   6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21};
    
    uint32_t k[] = {
       0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
       0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
       0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
       0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
       0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
       0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
       0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
       0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
       0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
       0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
       0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
       0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
       0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
       0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
       0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
       0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391};

    h0 = 0x67452301;
   h1 = 0xefcdab89;
   h2 = 0x98badcfe;
   h3 = 0x10325476;

   int new_len = ((((initial_len + 8) / 64) + 1) * 64) - 8;

   msg = calloc(new_len + 64, 1);
   memcpy(msg, initial_msg, initial_len);
   msg[initial_len] = 128;

   uint32_t bits_len = 8*initial_len;
   memcpy(msg + new_len, &bits_len, 4);

   int offset;
   for(offset=0; offset<new_len; offset += (512/8)) {
       
       uint32_t *w = (uint32_t *) (msg + offset);

       uint32_t a = h0;
       uint32_t b = h1;
       uint32_t c = h2;
       uint32_t d = h3;

       uint32_t i;
       for(i = 0; i<64; i++) {

           uint32_t f, g;

            if (i < 16) {
               f = (b & c) | ((~b) & d);
               g = i;
           } else if (i < 32) {
               f = (d & b) | ((~d) & c);
               g = (5*i + 1) % 16;
           } else if (i < 48) {
               f = b ^ c ^ d;
               g = (3*i + 5) % 16;
           } else {
               f = c ^ (b | (~d));
               g = (7*i) % 16;
           }

           uint32_t temp = d;
           d = c;
           c = b;

           b = b + LEFTROTATE((a + f + k[i] + w[g]), r[i]);
           a = temp;
       }

       h0 += a;
       h1 += b;
       h2 += c;
       h3 += d;

   }

   free(msg);

}

void md5string(uint8_t *msg, uint32_t len, char *result) {

    calcmd5(msg, len);
    uint8_t *p;
 
    p=(uint8_t *)&h0;
    sprintf(&result[0],"%2.2x%2.2x%2.2x%2.2x", p[0], p[1], p[2], p[3], h0);
    p=(uint8_t *)&h1;
    sprintf(&result[8],"%2.2x%2.2x%2.2x%2.2x", p[0], p[1], p[2], p[3], h1);
    p=(uint8_t *)&h2;
    sprintf(&result[16],"%2.2x%2.2x%2.2x%2.2x", p[0], p[1], p[2], p[3], h2);
    p=(uint8_t *)&h3;
    sprintf(&result[24],"%2.2x%2.2x%2.2x%2.2x", p[0], p[1], p[2], p[3], h3);
    result[32]='\0';
    
}

+ (NSString*) compute: (NSData*) data
{
    uint8_t *bytes = [data bytes];
    uint32_t length = [data length];
    
    char result[32+1];
    
    md5string(bytes, length, result);
    
    return [NSString stringWithFormat:@"%s", result];
}

@end