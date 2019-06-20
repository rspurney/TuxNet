#!/usr/bin/env python

#
# Copyright 2016, Daehwan Kim <infphilo@gmail.com>
#
# This file is part of HISAT 2.
#
# HISAT 2 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# HISAT 2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with HISAT 2.  If not, see <http://www.gnu.org/licenses/>.
#


import sys, os, subprocess, re
import inspect
import random
import glob
from argparse import ArgumentParser, FileType


"""
"""
def get_haplotypes(sra_run_info,
                   alignment):

    runs, run_to_genome = {}, {}
    for line in open(sra_run_info):
        line = line.strip()
        fields = line.split('\t')
        genome, run = fields[4], fields[0]
        if genome not in runs:
            runs[genome] = set()
        runs[genome].add(run)
        assert run not in run_to_genome
        run_to_genome[run] = genome

    prev_run = ""
    plus, minus = set(), set()
    for line in open(alignment):
        line = line.strip()
        fields = line.split('\t')
        read_id, flag, ref, pos, _, cigar = fields[:6]
        flag = int(flag)
        run = read_id.split('.')[0]

        if flag & 0x4 != 0:
            continue

        pos = int(pos) - 1
        
        if flag & 0x10 == 0:
            plus.add(pos)
        else:
            minus.add(pos)            

        if prev_run != "" and prev_run != run:
            if len(plus) > 0 and len(minus) > 0:
                if len(plus) > 1 or len(minus) > 1:
                    print run_to_genome[prev_run], prev_run, plus, minus
            plus, minus = set(), set()

        prev_run = run

    if run != "":
        if len(plus) > 0 and len(minus) > 0:
            if len(plus) > 1 or len(minus) > 1:
                print run_to_genome[run], run, plus, minus


"""
"""
if __name__ == '__main__':
    parser = ArgumentParser(
        description='get haplotypes from StrandSeq reads')
    parser.add_argument("sra_run_info",
                        nargs='?',
                        type=str,
                        help="SRA Run Info filename")
    parser.add_argument("alignment",
                        nargs='?',
                        type=str,
                        help="SAM file name")

    args = parser.parse_args()

    get_haplotypes(args.sra_run_info,
                   args.alignment)

