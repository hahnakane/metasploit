class Object
	def scan_iter
		case self
		when ::Array
			length.times { |i| yield self[i], "[#{i}]" }
		when ::Hash
			each { |k, v| yield v, "[#{k.inspect}]" ; yield k, "(key)" }
		else
			instance_variables.each { |i| yield instance_variable_get(i), ".#{i[1..-1]}" }
		end
	end

	# dumps to stdout the path to find some targets ( array of objects to match with == )
	def scan_for(targets, path, done={})
		done[object_id] = self if done.empty?
		t = nil
		if targets.find { |t| self == t }
			puts "found #{t} at #{path}"
		end
		scan_iter { |v, p|
			case v
			when Fixnum, Symbol; next
			end
			p = path+p
			if done[v.object_id]
				puts "loop #{p} -> #{done[v.object_id]}" if $VERBOSE
			else
				done[v.object_id] = p
				v.scan_for(targets, p, done)
			end
		}
	end
end