import json
import os.path as op
import sys

if (len(sys.argv) != 4):
    print "Usage python reset-transcriptalignmentset.py input_tool_contract_json input_merged_sorted_transcriptalignmentset_xml output_tool_contract_json"
    sys.exit(-1)

input_tool_contract_json = sys.argv[1]
input_merged_xml  = sys.argv[2]
output_tool_contract_json = sys.argv[3]
print "input tool contract json: {}".format(input_tool_contract_json)
print "input merged sorted transcript alignmentset xml: {}".format(input_merged_xml)
print "output tool contract json: {}".format(output_tool_contract_json)

d = json.load(open(input_tool_contract_json))
d['resolved_tool_contract']['input_files'][1] = op.abspath(op.expanduser(input_merged_xml))
d['resolved_tool_contract']['output_files'][0] = "out.fastq"
d['resolved_tool_contract']['output_files'][1] = "out.gff"
d['resolved_tool_contract']['output_files'][2] = "out.group.txt"
d['resolved_tool_contract']['output_files'][3] = "out.abundance.txt"
d['resolved_tool_contract']['output_files'][4] = "out.read_stat.txt"
d['resolved_tool_contract']['output_files'][5] = "out.report.json"
json.dump(d, open(output_tool_contract_json, 'w'))
