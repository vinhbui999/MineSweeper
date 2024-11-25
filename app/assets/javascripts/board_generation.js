let cols, rows, small_h, small_w;

document.addEventListener("DOMContentLoaded", function () {
  const container = document.getElementById("board-container");
  const canvas = document.getElementById("minesweeperBoard");
  const ctx = canvas.getContext("2d");

  const scrollTop = container.scrollTop;
  const scrollHeight = container.scrollHeight;
  const clientHeight = container.clientHeight;
  const scrollLeft = container.scrollLeft;
  const scrollWidth = container.scrollWidth;
  const clientWidth = container.clientWidth;

  const nearBottom =
    scrollTop + clientHeight >= (scrollHeight - clientHeight) / 4;
  const nearRightEdge =
    scrollLeft + clientWidth >= (scrollWidth - clientWidth) / 4;

  let cellSize = 20;

  if (total_rows * cellSize <= canvas.height) {
    canvas.height = total_rows * cellSize;
    small_h = true;
  }
  if (total_cols * cellSize <= canvas.width) {
    canvas.width = total_cols * cellSize;
    small_w = true;
  }
  if (!(small_h && small_w)) {
    cellSize = 10;
  }

  let mineData = [];
  let max_page = 0;
  let startRow = 0;
  let startCol = 0;
  let page = 1;
  let { visibleRows, visibleCols } = calculateVisibleDimensions();

  const perPage = visibleCols * visibleRows * cellSize * cellSize;

  async function loadMineData(
    startRow,
    startCol,
    visibleRows,
    visibleCols,
    page
  ) {
    const response = await fetch(
      `${mineDataUrl}?page=${page}&per_page=${perPage}`
    );
    const data = await response.json();
    mineData = [...mineData, ...data.mines];
    //data.mines;
    max_page = data.max_page;
    page = data.current_page;
    renderBoard(startRow, startCol, visibleCols, visibleRows);
    disabledButton();
  }

  function disabledButton() {
    if (startCol >= total_cols - visibleCols) {
      document.getElementById("loadRight").setAttribute("disabled", "disabled");
    } else {
      document.getElementById("loadRight").disabled = false;
    }
    if (startCol <= 0) {
      document.getElementById("loadLeft").setAttribute("disabled", "disabled");
    } else {
      document.getElementById("loadLeft").disabled = false;
    }

    if (startRow <= 0) {
      document.getElementById("loadUp").setAttribute("disabled", "disabled");
    } else {
      document.getElementById("loadUp").disabled = false;
    }

    if (startRow >= total_rows - visibleRows) {
      document.getElementById("loadDown").setAttribute("disabled", "disabled");
    } else {
      document.getElementById("loadDown").disabled = false;
    }
  }

  function calculateVisibleDimensions() {
    // Calculate number of rows, cols can able to display match the canvas size
    return {
      visibleRows: Math.floor(canvas.height / cellSize),
      visibleCols: Math.floor(canvas.width / cellSize),
    };
  }

  function renderBoard(startRow, startCol, visibleCols, visibleRows) {
    // Determine which row is topmost, col is leftmost
    // From it and start drawing

    // ensure drawing rows, cols less than or equal to inputed ones
    for (
      let row = startRow;
      row < Math.min(startRow + visibleRows, total_rows);
      row++
    ) {
      for (
        let col = startCol;
        col < Math.min(startCol + visibleCols, total_cols);
        col++
      ) {
        const x = (col - startCol) * cellSize;
        const y = (row - startRow) * cellSize;

        ctx.strokeStyle = "black";
        ctx.lineWidth = 1;
        ctx.strokeRect(x, y, cellSize, cellSize);
        ctx.fillStyle = "white";
        ctx.fillRect(x, y, cellSize, cellSize);

        const mineCell = mineData.find(
          (cell) => cell.row === row && cell.col === col
        );
        if (mineCell) {
          ctx.fillRect(x, y, cellSize, cellSize);
          ctx.fillStyle = "black";
          ctx.textAlign = "center";
          ctx.textBaseline = "middle";
          ctx.font = `${cellSize * 0.75}px Arial`; // Adjust font size
          ctx.fillText("💣", x + cellSize / 2, y + cellSize / 2);
        }
      }
    }
  }

  function debounce(func, wait) {
    let timeout;
    return function (...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }

  const loadMineWithDebounced = debounce(
    (startRow, startCol, visibleRows, visibleCols, page) => {
      loadMineData(startRow, startCol, visibleRows, visibleCols, page);
    },
    500
  );

  // Event listeners for buttons
  document.getElementById("loadLeft").addEventListener("click", () => {
    // Move left
    const { visibleRows, visibleCols } = calculateVisibleDimensions();
    startCol = Math.max(0, startCol - visibleCols);
    //startRow = Math.max(0, startRow - visibleRows);
    page--;
    loadMineWithDebounced(
      startRow,
      startCol,
      visibleRows,
      visibleCols,
      Math.max(0, page)
    );
  });

  document.getElementById("loadRight").addEventListener("click", () => {
    const { visibleRows, visibleCols } = calculateVisibleDimensions();
    startCol = Math.min(total_cols - visibleCols, startCol + visibleCols);
    page++;
    loadMineWithDebounced(startRow, startCol, visibleRows, visibleCols, page);
  });

  document.getElementById("loadUp").addEventListener("click", () => {
    const { visibleRows, visibleCols } = calculateVisibleDimensions();
    startRow = Math.max(0, startRow - visibleRows);
    loadMineWithDebounced(startRow, startCol, visibleRows, visibleCols, page);
  });

  document.getElementById("loadDown").addEventListener("click", () => {
    const { visibleRows, visibleCols } = calculateVisibleDimensions();
    startRow = Math.min(total_rows - visibleRows, startRow + visibleRows);
    loadMineWithDebounced(startRow, startCol, visibleRows, visibleCols, page);
  });

  loadMineData(startRow, startCol, visibleRows, visibleCols, page);
});
