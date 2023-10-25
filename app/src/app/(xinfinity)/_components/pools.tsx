"use client";

import * as React from "react";
import { useRouter } from "next/router";
import Image from "next/image";
import {
  ColumnDef,
  ColumnFiltersState,
  SortingState,
  VisibilityState,
  flexRender,
  getCoreRowModel,
  getFilteredRowModel,
  getPaginationRowModel,
  getSortedRowModel,
  useReactTable,
} from "@tanstack/react-table";
import { ArrowUpDown, ChevronDown, MoreHorizontal } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import {
  DropdownMenu,
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Input } from "@/components/ui/input";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Icons } from "@/components/Icons";
import { toast } from "@/hooks/use-toast";

const data: Payment[] = [
  {
    id: "m5gr84i9",
    amount: 316,
    status: "success",
    email: "ken99@yahoo.com",
    test: "test",
  },
  {
    id: "3u1reuv4",
    amount: 242,
    status: "success",
    email: "Abe45@gmail.com",
    test: "test",
  },
  {
    id: "derv1ws0",
    amount: 837,
    status: "processing",
    email: "Monserrat44@gmail.com",
    test: "test",
  },
  {
    id: "5kma53ae",
    amount: 874,
    status: "success",
    email: "Silas22@gmail.com",
    test: "test",
  },
  {
    id: "bhqecj4p",
    amount: 721,
    status: "failed",
    email: "carmella@hotmail.com",
    test: "test",
  },
];

const poolData: Pool[] = [
  {
    id: "1",
    pool: "PRNT/WXDC",
    TVL: 57580,
    volume24h: 496.34,
    volume7D: 2660,
  },
  {
    id: "2",
    pool: "XTT/XSP",
    TVL: 42120,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "3",
    pool: "BIC/WXDC",
    TVL: 4640,
    volume24h: 0,
    volume7D: 1,
  },
  {
    id: "4",
    pool: "PRNT/BIC",
    TVL: 1900,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "5",
    pool: "BIC/XSP",
    TVL: 1150,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "6",
    pool: "BIC/WXDC",
    TVL: 86117,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "7", // id to be address
    pool: "WXDC/xUSDT",
    TVL: 62371,
    volume24h: 34.23,
    volume7D: 24976,
  },
  {
    id: "8",
    pool: "BIC/xUSDT",
    TVL: 56485,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "9",
    pool: "BIC/xUSDT",
    TVL: 24849,
    volume24h: 0,
    volume7D: 0,
  },
  {
    id: "10",
    pool: "XSP/WXDC",
    TVL: 21514,
    volume24h: 1.13,
    volume7D: 4647,
  },
];

export type Payment = {
  id: string;
  amount: number;
  status: "pending" | "processing" | "success" | "failed";
  email: string;
  test: string;
};

export type Pool = {
  id: string;
  pool: string;
  TVL: number | string;
  volume24h: number;
  volume7D: number;
};

export const columns: ColumnDef<Pool>[] = [
  {
    id: "select",
    // header: ({ table }) => (
    //   <Checkbox
    //     className="text-black"
    //     checked={table.getIsAllPageRowsSelected()}
    //     onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
    //     aria-label="Select all"
    //   />
    // ),
    cell: ({ row }) => (
      //   <Checkbox
      //     checked={row.getIsSelected()}
      //     onCheckedChange={(value) => row.toggleSelected(!!value)}
      //     aria-label="Select row"
      //   />
      <Icons.logo className="h-8 w-8 rounded-md sm:h-6 sm:w-6" />
    ),

    enableSorting: false,
    enableHiding: false,
  },
  // {
  //   accessorKey: "status",
  //   header: "Status",
  //   cell: ({ row }) => (
  //     <div className="capitalize">{row.getValue("status")}</div>
  //   ),
  // },

  // add accesoary keys for pool, liquidity, volume24h
  {
    accessorKey: "pool",
    header: "Pool",
    cell: ({ row }) => <div className="capitalize">{row.getValue("pool")}</div>,
  },
  {
    accessorKey: "TVL",
    header: ({ column }) => {
      return (
        <Button
          variant="ghost"
          onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
        >
          TVL
          <ArrowUpDown className="ml-2 h-4 w-4" />
        </Button>
      );
    },
    cell: ({ row }) => <div className="lowercase">{row.getValue("TVL")}</div>,
  },
  {
    accessorKey: "volume24h",
    header: () => <div className="text-right">Volume 24h</div>,
    cell: ({ row }) => {
      const amount = parseFloat(row.getValue("volume24h"));

      const formatted = new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "USD",
      }).format(amount);

      return <div className="text-right font-medium">{formatted}</div>;
    },
  },
  {
    accessorKey: "volume7D",
    header: () => <div className="text-right">Volume 7D</div>,
    cell: ({ row }) => {
      const amount = parseFloat(row.getValue("volume7D"));

      // Format the amount as a dollar amount
      const formatted = new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "USD",
      }).format(amount);

      return <div className="text-right font-medium">{formatted}</div>;
    },
  },

  {
    id: "actions",
    enableHiding: false,
    cell: ({ row }) => {
      const payment = row.original;

      return (
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="h-8 w-8 p-0">
              <span className="sr-only">Open menu</span>
              <MoreHorizontal className="h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>Actions</DropdownMenuLabel>
            <DropdownMenuItem
              onClick={() => {
                navigator.clipboard.writeText(payment.id),
                  toast({
                    title: "success",
                    description: "Adress copied to clipboard",
                  });
              }}
            >
              Copy pool Address
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem>Trade This Pool</DropdownMenuItem>
            {/* <DropdownMenuItem>View payment details</DropdownMenuItem> */}
          </DropdownMenuContent>
        </DropdownMenu>
      );
    },
  },
];

export function Pools() {
  const [sorting, setSorting] = React.useState<SortingState>([]);
  const [columnFilters, setColumnFilters] = React.useState<ColumnFiltersState>(
    []
  );
  const [columnVisibility, setColumnVisibility] =
    React.useState<VisibilityState>({});
  const [rowSelection, setRowSelection] = React.useState({});



  const table = useReactTable({
    data: poolData,
    columns,
    onSortingChange: setSorting,
    onColumnFiltersChange: setColumnFilters,
    getCoreRowModel: getCoreRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
    onColumnVisibilityChange: setColumnVisibility,
    onRowSelectionChange: setRowSelection,
    state: {
      sorting,
      columnFilters,
      columnVisibility,
      rowSelection,
    },
  });

  return (
    <div className="w-full">
      <div className="flex items-center py-4">
        <Input
          placeholder="Filter pool..."
          value={(table.getColumn("pool")?.getFilterValue() as string) ?? ""}
          onChange={(event) =>
            table.getColumn("pool")?.setFilterValue(event.target.value)
          }
          className="max-w-sm bg-inherit"
        />
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="outline" className="ml-auto bg-inherit">
              Columns <ChevronDown className=" ml-2 h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            {table
              .getAllColumns()
              .filter((column) => column.getCanHide())
              .map((column) => {
                return (
                  <DropdownMenuCheckboxItem
                    key={column.id}
                    className="capitalize"
                    checked={column.getIsVisible()}
                    onCheckedChange={(value) =>
                      column.toggleVisibility(!!value)
                    }
                  >
                    {column.id}
                  </DropdownMenuCheckboxItem>
                );
              })}
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
      <div className="rounded-md border">
        <Table>
          <TableHeader>
            {table.getHeaderGroups().map((headerGroup) => (
              <TableRow key={headerGroup.id}>
                {headerGroup.headers.map((header) => {
                  return (
                    <TableHead className="text-white" key={header.id}>
                      {header.isPlaceholder
                        ? null
                        : flexRender(
                            header.column.columnDef.header,
                            header.getContext()
                          )}
                    </TableHead>
                  );
                })}
              </TableRow>
            ))}
          </TableHeader>
          <TableBody>
            {table.getRowModel().rows?.length ? (
              table.getRowModel().rows.map((row) => (
                <TableRow
                  onClick={() => {
                    window.location.href = `/app/${row.id}`;
                  }}
                  key={row.id}
                  data-state={row.getIsSelected() && "selected"}
                >
                  {row.getVisibleCells().map((cell) => (
                    <TableCell key={cell.id}>
                      {flexRender(
                        cell.column.columnDef.cell,
                        cell.getContext()
                      )}
                    </TableCell>
                  ))}
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell
                  colSpan={columns.length}
                  className="h-24 text-center"
                >
                  No results.
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>
      <div className="flex items-center justify-end space-x-2 py-4">
        <div className="flex-1 text-sm text-muted-foreground text-white">
          {table.getFilteredSelectedRowModel().rows.length} of{" "}
          {table.getFilteredRowModel().rows.length} row(s) selected.
        </div>
        <div className="space-x-2">
          <Button
            className="text-black"
            variant="outline"
            size="sm"
            onClick={() => table.previousPage()}
            disabled={!table.getCanPreviousPage()}
          >
            Previous
          </Button>
          <Button
            className="text-black"
            variant="outline"
            size="sm"
            onClick={() => table.nextPage()}
            disabled={!table.getCanNextPage()}
          >
            Next
          </Button>
        </div>
      </div>
    </div>
  );
}
