# Swish Project Notes



## General Questions

**Overview of approach:**
1. Read project specifications
2. Determine that steps 1-3 are related to SVN and CI. Steps 4+ are related to CD and Operations.
3. Work backwards from step 3 in the spec:
   1. Using Python 3, find a CVE -> [CVE-2022-48565](https://nvd.nist.gov/vuln/detail/CVE-2022-48565)
   2. Start with an impacted version of Python to show vulnerability scanning -> v3.9.0
   3. Start project at this version and then show an upgrade to a version that isn't impacted by CVE-2022-48565. -> v3.9.2
4. Use the official Python docker image as a starting point: https://hub.docker.com/_/python
   1. I prefer to use official images whenever possible because they tend to be higher quality and well maintained. It is not always possilbe to use official images though.
5. Work twords deploying a simple python HTTP server which returns hello world in Kubernetes.
6. Plan on opening an MR to address security issues.
7. Plan on opening an MR to address CI build times.



## Docker Build

Build without cache: 20.3s

Build with cache: 0.3s



## Security Advisories

* https://github.com/mdgreenwald/swish-project/pull/5



## References

* https://python-poetry.org/docs/faq#poetry-busts-my-docker-cache-because-it-requires-me-to-copy-my-source-files-in-before-installing-3rd-party-dependencies