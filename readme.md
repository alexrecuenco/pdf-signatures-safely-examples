
# Creating digital certificate signatures in PDF files with OSS

Using

https://pyhanko.readthedocs.io/en/latest/cli-guide/signing.html#signing-a-pdf-file-using-key-material-on-disk

You need:

- docker
- A certificate file (.p12) or (.pem) or similar

## Safety

We are using VERY sensitive information, so we would like it to be somewhat safer.

For that, the intention is to run this in a docker image such that:

- ✅ No internet connection can be made
- ✅ The secret data is not included in the build
- ❌ Preventing escalation (not done)

## Requirements

Docker

## To build

run the [`build.sh`](./build.sh)

## To run

Run [`run.sh`](./run.sh)


## To use

Use the command demondstrated in [`run.sh`](./run.sh), it should look something like

```
docker run --rm -i -t -v ./files:/app/files --network none "$TAG" /bin/sh
cd files
```

And now you run commands in your docker image, but modify things inside the  files/ folder

### Your certificate file

Add your certificate file(s) inside the folder files/,

**WARN: make sure you don't commit it by mistake, the git and docker ignore files are telling you not to do it**

### Attach custom signature

Modify the [`signature.png`](./files/signature.png) to whatever signature you use

An example is provided, taking almost verbatim from pyhanko's website. See the pyhanko.yml for further information in how to modify it

(That signature is fake, not my real signature btw)

### Example with .pem files

Invisible

```bash
cd files/
pyhanko sign addsig --field Sig1 pemder --key key.pem --cert cert.pem input.pdf output.pdf
```

Visible

```bash
# --field PABE/X1,Y1,X2,Y2/FieldName
pyhanko sign addsig --field 1/400,600,600,800/Signature pemder --key key.pem --cert cert.pem input.pdf output.pdf
```

### Example with .p12 files

Example

```bash
# -1 implies the last page
pyhanko sign addsig --field "-1/100,200,300,700/Signature" pkcs12 \
    input.pdf output.pdf secrets.p12
```

#### Multiple

It is not working as intended, note how the example here just uses one signature file, it is just testing, it obviously doesn't make sense to have just one file, you are meant to use one for each person

##### First attempt

If you do:

```bash
pyhanko sign addsig \
    --field 5/1,1,150,200/Signature5 \
    --field 4/1,1,150,200/Signature4 \
    --field 3/1,1,150,200/Signature3 \
    --field 2/1,1,150,200/Signature2 \
    --field 1/1,1,150,200/Signature1 \
    pkcs12 input.pdf output.pdf secrets.p12
```

It doesn't work (note how this is silly)


##### Second attempt

First create the fields
```bash
# --field PABE/X1,Y1,X2,Y2/FieldName Y=0 is at the bottom of the page
pyhanko sign addfields \
    --field 5/1,1,150,200/Signature5 \
    --field 4/1,1,150,200/Signature4 \
    --field 3/1,1,150,200/Signature3 \
    --field 2/1,1,150,200/Signature2 \
    --field 1/1,1,150,200/Signature1 \
    input.pdf output1000.pdf
```

Then sign them individually

```bash
pyhanko sign addsig --field Signature1 pkcs12 output1000.pdf output1000.pdf secrets.p12 && \
pyhanko sign addsig --field Signature2 pkcs12 output1000.pdf output1000.pdf secrets.p12 && \
pyhanko sign addsig --field Signature3 pkcs12 output1000.pdf output1000.pdf secrets.p12 && \
pyhanko sign addsig --field Signature4 pkcs12 output1000.pdf output1000.pdf secrets.p12 && \
pyhanko sign addsig --field Signature5 pkcs12 output1000.pdf output1000.pdf secrets.p12
```

HOWEVER All previous signatures are invalid, and only the last one is considered valid (duh!)

So, I don't know yet how to do it
