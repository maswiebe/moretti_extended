This repository contains Stata .do files for performing a replication of "[The Effect of High-Tech Clusters on the Productivity of Top Inventors](https://www.aeaweb.org/articles?id=10.1257/aer.20191277)", Moretti (2021).

To combine my code with the data, first download this repository, then download the original [replication package](https://www.openicpsr.org/openicpsr/project/140662/version/V1/view) and extract the folder 'AER_UPLOADED' to the directory 'data/'.

To rerun the analyses, execute the Stata script `run.do`. 
Note that you need to set the path in `run.do` on line 2, to define the location of the folder that contains these scripts.