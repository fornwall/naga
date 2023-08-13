struct Vertex {
    @location(0) position: vec4<f32>,
};

struct Offset {
    @location(1) position: vec4<f32>,
};

struct VertexOutput {
  @builtin(position) position: vec4<f32>
};

@vertex
fn vs_main(vertex: Vertex, offset: Offset, @location(2) position: vec4<f32>) -> VertexOutput {
    var out: VertexOutput;
    out.position = vertex.position + offset.position + position;
    return out;
}
