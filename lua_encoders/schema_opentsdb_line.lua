require "cjson"

local tsdb_line_protocol = require "tsdb_line_protocol"

local decoder_config = {
    decimal_precision = read_config("decimal_precision") or "6",
    name_prefix = read_config("name_prefix") or nil,
    name_prefix_delimiter = read_config("name_prefix_delimiter") or nil,
    skip_fields_str = read_config("skip_fields") or nil,
    source_value_field = read_config("source_value_field") or nil,
    tag_fields_str = read_config("tag_fields") or "**all_base**",
    timestamp_precision = read_config("timestamp_precision") or "ms",
    value_field_key = read_config("value_field_key") or "value"
}

local config = tsdb_line_protocol.set_config(decoder_config)

function process_message()

    local api_message = tsdb_line_protocol.tsdb_line_msg(config)
    --local msg = decode_message(read_message("raw"))
    local pok, str = pcall(cjson.encode, api_message)
    if not pok then return -1, "Failed to encode JSON." end
    inject_payload("txt", "tsdb_line", str)
    return 0
end

