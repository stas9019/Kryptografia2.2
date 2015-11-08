#include <mpg123.h>
#include <ao/ao.h>

#include <stddef.h>
#include <stdlib.h>



#define BITS 8

/* A 256 bit key */
unsigned char *key = (unsigned char *)"01234567890123456789012345678901";


int play(char* filepath, int start_second);


int main(int argc, char *argv[])
{

    int start_second = 0.0;

    if(argc < 2)
        exit(0);

    if(argc == 3)
        sscanf(argv[2], "%d", &start_second );

    char* filepath = argv[1];





    play(filepath, start_second );


}

int play( char* filepath, int start_second)
{

    mpg123_handle *mh;
    unsigned char *buffer;
    size_t buffer_size;
    size_t done;
    int err;

    int driver;
    ao_device *dev;

    ao_sample_format format;
    int channels, encoding;
    long rate;



    /* initializations */
    ao_initialize();
    driver = ao_default_driver_id();
    mpg123_init();
    mh = mpg123_new(NULL, &err);
    buffer_size = mpg123_outblock(mh);
    buffer = (unsigned char*) malloc(buffer_size * sizeof(unsigned char));

    /* open the file and get the decoding format */


    mpg123_open(mh, filepath);
    //mpg123_open_fd(mh, 1);        may be for shm

    mpg123_getformat(mh, &rate, &channels, &encoding);


    off_t pos = mpg123_timeframe(mh ,start_second);
    mpg123_seek_frame(mh, pos, SEEK_SET);


    /* set the output format and open the output device */
    format.bits = mpg123_encsize(encoding) * BITS;
    format.rate = rate;
    format.channels = channels;
    format.byte_format = AO_FMT_NATIVE;
    format.matrix = 0;
    dev = ao_open_live(driver, &format, NULL);

    /* decode and play */
    while (mpg123_read(mh, buffer, buffer_size, &done) == MPG123_OK)
        ao_play(dev, (char*)buffer, done);

    /* clean up */
    free(buffer);
    ao_close(dev);
    mpg123_close(mh);
    mpg123_delete(mh);
    mpg123_exit();
    ao_shutdown();

    return 0;



}
