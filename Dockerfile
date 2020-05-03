FROM python:2.7-slim-buster

# Setup debian packages
RUN apt update && apt install -y \
    build-essential=12.6 \
    curl=7.64.0-4+deb10u1 \
    dcm2niix=1.0.20181125-1 \
    file=1:5.35-4+deb10u1 \
    git=1:2.20.1-2+deb10u3

# Setup FSL
ENV FSLDIR /usr/local/fsl
RUN curl -O https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py
RUN python fslinstaller.py -d ${FSLDIR} -q
ENV FSLOUTPUTTYPE NIFTI_GZ
ENV PATH ${FSLDIR}/bin:${PATH}
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$FSLDIR

# Setup python
COPY requirements.txt .
RUN pip install -r requirements.txt
