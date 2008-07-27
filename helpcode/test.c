#include <gtk/gtk.h>
#include <gpgme.h>

int main ( int argc, char **argv)
{
	gpgme_data_t dh_plain = 0, dh_cipher = 0;
	gpgme_error_t err;
	gpgme_ctx_t ctx;

	gtk_init(&argc, &argv);

	gpgme_new(&ctx);

	gpgme_set_armor(ctx, 1);

	char *plain = "aapnootmies12";
	gpgme_data_new_from_mem(&dh_plain,plain, strlen(plain), 0);

	gpgme_data_new(&dh_cipher);

	gpgme_key_t tmp_key[2];
	tmp_key[1] = 0;

	err = gpgme_get_key(ctx, "74F46203", &tmp_key[0], 1);

		err = gpgme_op_encrypt(ctx, &tmp_key[0], GPGME_ENCRYPT_ALWAYS_TRUST, dh_plain, dh_cipher);
		if(err)
		{
			printf("3: %s\n", gpgme_strerror(err));
		}


	size_t nRead = 0;
	gchar *cipher = NULL;
	cipher = gpgme_data_release_and_get_mem(dh_cipher, &nRead);
	gpgme_data_release(dh_plain);
	gpgme_data_new(&dh_plain);
	gpgme_data_new_from_mem(&dh_cipher,cipher, strlen(cipher), 0);

	size_t old;
	printf("%i\n", nRead);
	for(old =0;old<nRead;old++)
		putchar(cipher[old]);
	fflush(NULL);
	gpgme_free(cipher);
	err = gpgme_op_decrypt(ctx, dh_cipher, dh_plain);
		if(err)
		{
			printf("3: %s\n", gpgme_strerror(err));
		}
	cipher = gpgme_data_release_and_get_mem(dh_plain, &nRead);

	printf("%i\n", nRead);
	for(old =0;old<nRead;old++)
		putchar(cipher[old]);
	fflush(NULL);

	gpgme_free(cipher);
	gpgme_key_unref(tmp_key[0]);
	/* Release data buffers */
	gpgme_data_release(dh_cipher);

	gpgme_release(ctx);
}
