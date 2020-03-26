# cjeu_network

## Introduction

The repository contains citation network data for the Court of Justice of the European Union conisting of all references in all CJEU decision published in the EU's Eur-lex database. The data builds on metadata collected from Eur-lex database, processed at PluriCourts, and that forms part of the CJEU database project. 

The data has been updated to include all changes until 4 March 2020. The network consists of 171,183 references (edges in the network) between 22,422 cases (vertices in the network). The data contains the R-script used to generate the data and two data files:
* a network file (.gml) containing all information, including vertices and edges with attributes and
* a data frame file (.csv) file containing network centrality measures and clustering information by judgment.

The ECLI numbers is used as the unique judgment identifier. The data includes the following centrality measurements:
* In- and outdegree
* PageRank (with a damping factor of 0.5) [1]
* Authority and Hub Score [2]
* Initial Hub Score [3]
* HubRank [4]
* Betweenness [5], [6]
Additionally, the data contains community memberships calculated using the InfoMap equation. [7]

## Suggested citation

Johan Lindholm, _CJEU Citation Network_, 4 March 2020. http://https://github.com/jojolindholm/cjeu_network

## Sources

[1] Sergey Brin and Larry Page: The Anatomy of a Large-Scale Hypertextual Web Search Engine. Proceedings of the 7th World-Wide Web Conference, Brisbane, Australia, April 1998.

[2] J. Kleinberg. Authoritative sources in a hyperlinked environment. Proc. 9th ACM-SIAM Symposium on Discrete Algorithms, 1998. Extended version in Journal of the ACM 46(1999). Also appears as IBM Research Report RJ 10076, May 1997.

[3] Yonatan Lupu and Erik Voeten (2012). Precedent in International Courts: A Network Analysis of Case Citations by the European Court of Human Rights. British Journal of Political Science, 42, pp 413-439 doi:10.1017/S0007123411000433.

[4] Mattias Derlén and Johan Lindholm, Is it Good Law? Network Analysis and the CJEU’s Internal Market Jurisprudence
Journal of International Economic Law, 2017, 20, 257–277 doi: 10.1093/jiel/jgx011

[5] Freeman, L.C. (1979). Centrality in Social Networks I: Conceptual Clarification. Social Networks, 1, 215-239.

[6] Ulrik Brandes, A Faster Algorithm for Betweenness Centrality. Journal of Mathematical Sociology 25(2):163-177, 2001.

[7] M. Rosvall and C. T. Bergstrom, Maps of information flow reveal community structure in complex networks, PNAS 105, 1118 (2008) http://dx.doi.org/10.1073/pnas.0706851105, http://arxiv.org/abs/0707.0609
