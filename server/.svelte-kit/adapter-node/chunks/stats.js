var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
function daysBetween(first, last) {
  return (last.getTime() - first.getTime()) / (1e3 * 60 * 60 * 24);
}
__name(daysBetween, "daysBetween");
const line = /* @__PURE__ */ __name((pointA, pointB) => {
  const lengthX = pointB[0] - pointA[0];
  const lengthY = pointB[1] - pointA[1];
  return {
    length: Math.sqrt(Math.pow(lengthX, 2) + Math.pow(lengthY, 2)),
    angle: Math.atan2(lengthY, lengthX)
  };
}, "line");
const controlPoint = /* @__PURE__ */ __name((current, previous, next, reverse = false) => {
  const p = previous || current;
  const n = next || current;
  const smoothing = 0.2;
  const o = line(p, n);
  const angle = o.angle + (reverse ? Math.PI : 0);
  const length = o.length * smoothing;
  const x = current[0] + Math.cos(angle) * length;
  const y = current[1] + Math.sin(angle) * length;
  return [x, y];
}, "controlPoint");
const bezierCommand = /* @__PURE__ */ __name((point, i, a) => {
  const [cpsX, cpsY] = controlPoint(a[i - 1], a[i - 2], point);
  const [cpeX, cpeY] = controlPoint(point, a[i - 1], a[i + 1], true);
  return `C ${stringify(cpsX)},${stringify(cpsY)} ${stringify(cpeX)},${stringify(cpeY)} ${stringify(point[0])},${stringify(point[1])}`;
}, "bezierCommand");
function stringify(value) {
  if (isNaN(value)) {
    return "0";
  }
  const fixed = value.toFixed(1);
  if (fixed.endsWith(".0")) {
    return fixed.substring(0, fixed.length - 2);
  }
  return fixed;
}
__name(stringify, "stringify");
const svgPath = /* @__PURE__ */ __name((points) => {
  const d = points.reduce((acc, point, i, a) => i === 0 ? (
    // if first point
    `M ${point[0]},${point[1]}`
  ) : (
    // else
    `${acc} ${bezierCommand(point, i, a)}`
  ), "");
  return d;
}, "svgPath");
function getPath(courses) {
  const first = courses[0];
  const last = courses.at(-1);
  if (!first || !last) {
    return "";
  }
  const totalDays = daysBetween(first.date, last.date);
  const buckets = new Array(totalDays).fill(1);
  for (const course of courses) {
    const index = daysBetween(first.date, course.date);
    buckets[index] = (buckets[index] ?? 0) + 1;
  }
  const maxCount = Math.max(...buckets);
  const path = [[0, 100]];
  for (let i = 0; i < buckets.length; i++) {
    const x = i / (buckets.length - 1) * 100;
    const y = 100 - buckets[i] / maxCount * 80;
    path.push([x, y]);
  }
  path.push([100, 100]);
  return svgPath(path);
}
__name(getPath, "getPath");
export {
  getPath as g
};
